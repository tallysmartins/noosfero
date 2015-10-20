class SoftwareInfo < ActiveRecord::Base
  acts_as_having_settings :field => :settings

  SEARCHABLE_SOFTWARE_FIELDS = {
    :acronym => 1,
    :finality => 2,
  }

  SEARCHABLE_SOFTWARE_CLASSES = [
    SoftwareInfo,
    Community,
    ProgrammingLanguage,
    DatabaseDescription,
    Category
  ]

  scope :search_by_query, lambda { |query = "", env = Environment.default|
    filtered_query = query.gsub(/[\|\(\)\\\/\s\[\]'"*%&!:]/,' ').split.map{|w| w += ":*"}.join('|')
    search_fields = SoftwareInfo.pg_search_plugin_fields

    if query.empty?
      SoftwareInfo.joins(:community).where("profiles.visible = ? AND environment_id = ? ", true, env.id)
    else
      searchable_software_objects = SoftwareInfo.transform_list_in_methods_list(SEARCHABLE_SOFTWARE_CLASSES)
      includes(searchable_software_objects).joins(:community).where("to_tsvector('simple', #{search_fields}) @@ to_tsquery('#{filtered_query}')").where("profiles.visible = ? AND environment_id = ?", true, env.id)
    end
  }

  def self.transform_list_in_methods_list list
    methods_list = []

    list.each do |element|
      if SoftwareInfo.instance_methods.include?(element.to_s.underscore.to_sym)
        methods_list << element.to_s.underscore.to_sym
      elsif SoftwareInfo.instance_methods.include?(element.to_s.underscore.pluralize.to_sym)
        methods_list << element.to_s.underscore.pluralize.to_sym
      end
    end

    methods_list
  end

  def self.pg_search_plugin_fields
    SEARCHABLE_SOFTWARE_CLASSES.collect { |one_class|
      self.get_searchable_fields(one_class)
    }.join(" || ' ' || ")
  end

  def self.get_searchable_fields one_class
    searchable_fields = one_class::SEARCHABLE_SOFTWARE_FIELDS.keys.map(&:to_s).sort.map {|f| "coalesce(#{one_class.table_name}.#{f}, '')"}.join(" || ' ' || ")
    searchable_fields
  end

  SEARCH_FILTERS = {
    :order => %w[],
    :display => %w[full]
  }

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
  has_many :categories, :through => :community

  belongs_to :community, :dependent => :destroy
  belongs_to :license_info

  has_one :software_categories

  validates_length_of :finality, :maximum => 4000
  validates_length_of :objectives, :maximum => 4000
  validates_length_of :features, :maximum => 4000
  validates_presence_of :finality, :community, :license_info

  validate :validate_acronym

  settings_items :another_license_version, :default => 'Another'
  settings_items :another_license_link, :default => '#'
  settings_items :sisp, :default => false

  serialize :agency_identification
  serialize :software_requirements
  serialize :hardware_requirements
  serialize :documentation
  serialize :system_applications
  serialize :active_versions
  serialize :estimated_cost
  serialize :responsible
  serialize :responsible_for_acquirement
  serialize :system_info
  serialize :development_info
  serialize :maintenance
  serialize :standards_adherence
  serialize :platform

  # used on find_by_contents
  def self.like_search name
    joins(:community).where(
      "name ILIKE ? OR acronym ILIKE ? OR finality ILIKE ?",
      "%#{name}%", "%#{name}%", "%#{name}%"
    )
  end

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
    license_another = LicenseInfo.find_by_version("Another")

    if license_another && self.license_info_id == license_another.id
      license_another.version = self.another_license_version
      license_another.link = self.another_license_link
      license_another
    else
      super
    end
  end

  def another_license(version, link)
    license_another = LicenseInfo.find_by_version("Another")

    if license_another
      self.another_license_version = version
      self.another_license_link = link
      self.license_info = license_another
      self.save!
    end
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
    identifier = attributes.delete(:identifier)
    image_builder = attributes.delete(:image_builder)
    license_info = attributes.delete(:license_info)
    another_license_version = attributes.delete(:another_license_version)
    another_license_link = attributes.delete(:another_license_link)

    software_info = SoftwareInfo.new(attributes)
<<<<<<< HEAD
    if !requestor.is_admin?
=======
    unless environment.admins.include? requestor
>>>>>>> Refactor software_communities.
      CreateSoftware.create!(
        attributes.merge(
          :requestor => requestor,
          :environment => environment,
          :name => name,
          :identifier => identifier,
<<<<<<< HEAD
          :license_info => license_info,
          :another_license_version => another_license_version,
          :another_license_link => another_license_link
=======
          :license_info => license_info
>>>>>>> Refactor software_communities.
        )
      )
    else
      software_template = SoftwareHelper.software_template

      community_hash = {:name => name}
      community_hash[:identifier] = identifier
      community_hash[:image_builder] = image_builder if image_builder

      community = Community.new(community_hash)
      community.environment = environment

      unless software_template.blank?
        community.template_id = software_template.id
      end

      community.save!
      community.add_admin(requestor)

      software_info.community = community
      software_info.license_info = license_info
<<<<<<< HEAD
      software_info.verify_license_info(another_license_version, another_license_link)
      software_info.save!
    end

=======
      software_info.save!
    end

    software_info.verify_license_info(another_license_version, another_license_link)
    software_info.save
>>>>>>> Refactor software_communities.
    software_info
  end

  def verify_license_info another_license_version, another_license_link
    license_another = LicenseInfo.find_by_version("Another")

    if license_another && self.license_info_id == license_another.id
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
