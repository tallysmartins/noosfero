# A Profile is the representation and web-presence of an individual or an
# organization. Every Profile is attached to its Environment of origin,
# which by default is the one returned by Environment:default.
class Profile < ActiveRecord::Base

  module Roles
    def self.admin
      ::Role.find_by_key('profile_admin')
    end
    def self.member
      ::Role.find_by_key('profile_member')
    end
    def self.moderator
      ::Role.find_by_key('profile_moderator')
    end
  end

  PERMISSIONS[:profile] = {
    'edit_profile'        => N_('Edit profile'),
    'destroy_profile'     => N_('Destroy profile'),
    'manage_memberships'  => N_('Manage memberships'),
    'post_content'        => N_('Post content'),
    'edit_profile_design' => N_('Edit profile design'),
    'manage_products'     => N_('Manage products'),
    'manage_friends'      => N_('Manage friends'),
    'validate_enterprise' => N_('Validate enterprise'),
    'peform_task'         => N_('Peform task'),
  }
  
  acts_as_accessible

  acts_as_having_boxes

  acts_as_searchable :fields => [ :name, :identifier ]

  acts_as_having_settings :field => :data

  # Valid identifiers must match this format.
  IDENTIFIER_FORMAT = /^[a-z][a-z0-9]+([_-][a-z0-9]+)*$/

  # These names cannot be used as identifiers for Profiles
  RESERVED_IDENTIFIERS = %w[
  admin
  system
  myprofile
  profile
  cms
  community
  test
  search
  not_found
  cat
  tag
  environment
  ]

  belongs_to :user

  has_many :domains, :as => :owner
  belongs_to :environment
  
  has_many :role_assignments, :as => :resource

  has_many :articles, :dependent => :destroy
  belongs_to :home_page, :class_name => Article.name, :foreign_key => 'home_page_id'

  has_one :image, :as => :owner
  
  has_many :consumptions
  has_many :consumed_product_categories, :through => :consumptions, :source => :product_category
  
  has_many :tasks, :foreign_key => :target_id

  def top_level_articles(reload = false)
    if reload
      @top_level_articles = nil
    end
    @top_level_articles ||= Article.top_level_for(self)
  end
  
  # Sets the identifier for this profile. Raises an exception when called on a
  # existing profile (since profiles cannot be renamed)
  def identifier=(value)
    unless self.new_record?
      raise ArgumentError.new(_('An existing profile cannot be renamed.'))
    end
    self[:identifier] = value
  end

  validates_presence_of :identifier, :name
  validates_format_of :identifier, :with => IDENTIFIER_FORMAT
  validates_exclusion_of :identifier, :in => RESERVED_IDENTIFIERS
  validates_uniqueness_of :identifier

  before_create :set_default_environment
  def set_default_environment
    if self.environment.nil?
      self.environment = Environment.default
    end
    true
  end

  # registar callback for creating boxes after the object is created. 
  hacked_after_create :create_default_set_of_boxes
  
  # creates the initial set of boxes when the profile is created. Can be
  # overriden for each subclass to create a custom set of boxes for its
  # instances.    
  def create_default_set_of_boxes
    3.times do
      self.boxes << Box.new
    end
    true
  end

  # Returns information about the profile's owner that was made public by
  # him/her.
  #
  # The returned value must be an object that responds to a method "summary",
  # which must return an array in the following format:
  #
  #   [
  #     [ 'First Field', first_field_value ],
  #     [ 'Second Field', second_field_value ],
  #   ]
  #
  # This information shall be used by user interface to present the
  # information.
  #
  # In this class, this method returns nil, what is interpreted as "no
  # information at all". Subclasses must override this method to provide their
  # specific information.
  def info
    nil
  end

  # returns the contact email for this profile. By default returns the the
  # e-mail of the owner user.
  #
  # Subclasses may -- and should -- override this method.
  def contact_email
    self.user ? self.user.email : nil
  end

  # gets recent documents in this profile, ordered from the most recent to the
  # oldest.
  #
  # +limit+ is the maximum number of documents to be returned. It defaults to
  # 10.
  def recent_documents(limit = 10)
    self.articles.recent(limit)
  end

  class << self

    # finds a profile by its identifier. This method is a shortcut to
    # +find_by_identifier+.
    #
    # Examples:
    #
    #  person = Profile['username']
    #  org = Profile.['orgname']
    def [](identifier)
      self.find_by_identifier(identifier)
    end

  end

  def superior_instance
    environment
  end

  # returns +false+
  def person?
    self.kind_of?(Person) 
  end

  def enterprise?
    self.kind_of?(Enterprise)
  end

  def organization?
    self.kind_of?(Organization)
  end

  # returns false.
  def is_validation_entity?
    false
  end

  def url
    generate_url(url_options.merge(:controller => 'content_viewer', :action => 'view_page', :page => []))
  end

  def admin_url
    generate_url(url_options.merge(:controller => 'profile_editor', :action => 'index'))
  end

  def public_profile_url
    generate_url(url_options.merge(:controller => 'profile', :action => 'index'))
  end

  def generate_url(options)
    url_options.merge(options)
  end

  def url_options
    options = { :host => self.environment.default_hostname, :profile => self.identifier}

    # help developers by generating a suitable URL for development environment 
    if (ENV['RAILS_ENV'] == 'development')
      options.merge!(development_url_options)
    end

    options
  end

  # FIXME couldn't think of a way to test this.
  #
  # Works (tested by hand) on Rails 2.0.2, with mongrel. Should work with
  # webrick too.
  def development_url_options # :nodoc:
    if Object.const_defined?('OPTIONS')
      { :port => OPTIONS[:port ]}
    else
      {}
    end
  end

  # FIXME this can be SLOW
  def tags(public_only = false)
    totals = {}
    articles.each do |article|
      article.tags.each do |tag|
        if totals[tag.name]
          totals[tag.name] += 1
        else
          totals[tag.name] = 1
        end
      end
    end
    totals
  end

  def find_tagged_with(tag)
    # FIXME: this can be SLOW
    articles.select {|item| item.tags.map(&:name).include?(tag) }
  end

  # Tells whether a specified profile has members or nor.
  #
  # On this class, returns <tt>false</tt> by default.
  def has_members?
    false
  end

  hacked_after_create :insert_default_homepage_and_feed
  def insert_default_homepage_and_feed
    hp = self.articles.build(:name => _("%s's home page") % self.name, :body => _("<p>This is a default homepage created for %s. It can be changed though the control panel.</p>") % self.name)
    hp.save!
    self.home_page = hp
    self.save!

    feed = RssFeed.new(:name => 'feed')
    self.articles << feed
    feed.save!
  end

  # Adds a person as member of this Profile.
  #
  # TODO if the subscription to the profile (closed Community, Enterprise etc)
  # is not open, instead of affiliating directly this method should create a
  # suitable task and assign it to the profile.
  def add_member(person)
    self.affiliate(person, Profile::Roles.member)
  end

end
