class SoftwareInfo < ActiveRecord::Base
  acts_as_having_settings :field => :settings

  SEARCH_FILTERS = []
  SEARCH_DISPLAYS = %w[full]

  def self.default_search_display
    'full'
  end

  attr_accessible :e_mag, :icp_brasil, :intern, :e_ping, :e_arq,
                  :operating_platform

  attr_accessible :demonstration_url, :acronym, :objectives, :features,
                  :license_info

  attr_accessible :community_id, :finality, :repository_link, :public_software,
                  :first_edit

  has_many :libraries, :dependent => :destroy
  has_many :software_databases
  has_many :database_descriptions, :through => :software_databases
  has_many :software_languages
  has_many :operating_systems
  has_many :programming_languages, :through => :software_languages
  has_many :operating_system_names, :through => :operating_systems

  belongs_to :community
  belongs_to :license_info

  has_one :software_categories

  validates_length_of :finality, :maximum => 140
  validates_length_of :objectives, :maximum => 4000
  validates_length_of :features, :maximum => 4000

  validate :validate_acronym

  settings_items :another_license_version, :another_license_link

  # used on find_by_contents
  scope :like_search, lambda{ |name|
    joins(:community).where(
      "name ILIKE ? OR acronym ILIKE ?", "%#{name}%", "%#{name}%"
    )
  }

  scope :search, lambda { |name="", database_description_id = "",
    programming_language_id = "", operating_system_name_id = "",
    license_info_id = "", e_ping = "", e_mag = "", internacionalizable = "",
    icp_brasil = "", e_arq = "", software_categories = "" |

    like_sql = ""
    values = []

    unless name.blank?
      like_sql << "name ILIKE ? OR identifier ILIKE ? AND "
      values << "%#{name}%" << "%#{name}%"
    end

    like_sql = like_sql[0..like_sql.length-5]

    {
      :joins => [:community],
      :conditions=>[like_sql, *values]
    }
  }

  def license_info
    license = LicenseInfo.find_by_id self.license_info_id

    if license == LicenseInfo.find_by_version("Another")
      LicenseInfo.new(
        :version => self.another_license_version,
        :link => self.another_license_link
      )
    else
      license
    end
  end

  def another_license(version, link)
    self.another_license_version = version
    self.another_license_link = link
    self.license_info = LicenseInfo.find_by_version("Another")
    self.save!
  end

  def validate_name_lenght
    if self.community.name.size > 100
      self.errors.add(
        :base,
        _("Name is too long (maximum is %{count} characters)")
      )
      false
    end
    true
  end

  # if create_after_moderation receive a model object, would be possible to reuse core method
  def self.create_after_moderation(requestor, attributes = {})
    environment = attributes.delete(:environment)
    name = attributes.delete(:name)
    license_info = attributes.delete(:license_info)
    another_license_version = attributes.delete(:another_license_version)
    another_license_link = attributes.delete(:another_license_link)

    software_info = SoftwareInfo.new(attributes)
    if !environment.admins.include? requestor
      CreateSoftware.create!(
        attributes.merge(
          :requestor => requestor,
          :environment => environment,
          :name => name,
          :license_info => license_info
        )
      )
    else
      software_template = Community["software"]
      community = Community.new(:name => name)
      community.environment = environment

      if (!software_template.blank? && software_template.is_template)
        community.template_id = software_template.id
      end

      software_info.license_info = license_info
      software_info.save
      community.software_info = software_info
      community.save!
      community.add_admin(requestor)
    end

    software_info.verify_license_info(another_license_version, another_license_link)
    software_info.save!
    software_info
  end

  def verify_license_info another_license_version, another_license_link
    if self.license_info_id == LicenseInfo.find_by_version("Another").id
      version = another_license_version
      link = another_license_link

      self.another_license(version, link)
    end
  end


  def validate_acronym
    self.acronym = "" if self.acronym.nil?
    if self.acronym.length > 10 && self.errors.messages[:acronym].nil?
      self.errors.add(:acronym, _("can't have more than 10 characteres"))
      false
    elsif self.acronym.match(/\s+/)
      self.errors.add(:acronym, _("can't have whitespaces"))
      false
    end
    true
  end

  def valid_operating_systems
    if self.operating_systems.empty?
      self.errors.add(:operating_system, _(": at least one must be filled"))
    end
  end

  def valid_software_info
    if self.software_languages.empty?
      self.errors.add(:software_languages, _(": at least one must be filled"))
    end
  end

  def valid_databases
    if self.software_databases.empty?
      self.errors.add(:software_databases, _(": at least one must be filled"))
    end
  end

  def visible?
    self.community.visible?
  end

  def name
    self.community.name
  end

  def short_name
    self.community.short_name
  end

  def identifier
    self.community.identifier
  end
end
