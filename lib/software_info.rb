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
    DatabaseDescription
  ]

  scope :search_by_query, lambda {|query = ""|
    filtered_query = query.gsub(/[\|\(\)\\\/\s\[\]'"*%&!:]/,' ').split.map{|w| w += ":*"}.join('|')
    search_fields = SoftwareInfo.pg_search_plugin_fields

    if query.empty?
      SoftwareInfo.all
    else
      searchable_software_objects = SoftwareInfo.transform_list_in_methods_list(SEARCHABLE_SOFTWARE_CLASSES)
      includes(searchable_software_objects).where("to_tsvector('simple', #{search_fields}) @@ to_tsquery('#{filtered_query}')")
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

  belongs_to :community, :dependent => :destroy
  belongs_to :license_info

  has_one :software_categories

  validates_length_of :finality, :maximum => 120
  validates_length_of :objectives, :maximum => 4000
  validates_length_of :features, :maximum => 4000
  validates_presence_of :finality

  validate :validate_acronym

  settings_items :another_license_version, :another_license_link

  # used on find_by_contents
  scope :like_search, lambda{ |name|
    joins(:community).where(
      "name ILIKE ? OR acronym ILIKE ? OR finality ILIKE ?",
      "%#{name}%", "%#{name}%", "%#{name}%"
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
    license_another = LicenseInfo.find_by_version("Another")

    if license_another && license.id == license_another.id
      LicenseInfo.new(
        :version => self.another_license_version,
        :link => self.another_license_link
      )
    else
      license
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

      community_hash = {:name => name}
      community_hash[:identifier] = identifier
      community_hash[:image_builder] = image_builder if image_builder

      community = Community.new(community_hash)
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
