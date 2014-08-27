class SoftwareInfo < ActiveRecord::Base
  attr_accessible :e_mag, :icp_brasil, :intern, :e_ping, :e_arq, :operating_platform, :demonstration_url, :acronym, :objectives, :features, :license_infos_id, :community_id

  has_many :libraries, :dependent => :destroy
  has_many :software_databases
  has_many :database_descriptions, :through => :software_databases
  has_many :software_languages
  has_many :operating_systems 
  has_many :programming_languages, :through => :software_languages
  has_many :operating_system_names, :through => :operating_systems

  belongs_to :community
  belongs_to :license_info

  has_one :controlled_vocabulary

  validate :validate_operating_platform, :validate_acronym, :valid_software_info, :valid_databases, :valid_operating_systems

  # used on find_by_contents
  scope :like_search, lambda{ |name|
    joins(:community).where("name ilike ?", "%#{name}%")
  }

  scope :search, lambda { |name="", database_description="", programming_language="", operating_system="",
    controlled_vocabulary="", license_info="", e_ping="", e_mag="",
    icp_brasil="", e_arq="", internacionalizable=""|

    like_sql = ""
    values = []

    unless name.nil? and name.blank?
      like_sql << "name ILIKE ? AND "
      values << "%#{name}%"
    end

    unless database_description.nil? and database_description.blank?
      software_databases = SoftwareDatabase.where(:database_description_id => database_description)
      like_sql << "software_databases ILIKE ? AND "
      values << "%#{software_databases}%"
    end

    unless programming_language.nil? and programming_language.blank?
      like_sql << "programming_language_id ILIKE ? AND "
      values << "%#{programming_language}%"
    end

    unless operating_system.nil? and operating_system.blank?
      like_sql << "operating_system_id ILIKE ? AND "
      values << "%#{operating_system}%"
    end

    unless license_info.nil? and license_info.blank?
      like_sql << "license_info_id ILIKE ? AND "
      values << "%#{license_info}%"
    end

    unless e_ping.nil? and e_ping.blank? and e_ping == "Any"
      like_sql << "e_ping ILIKE ? AND "
      values << "%#{e_ping}%"
    end

    unless e_mag.nil? and e_mag.blank? and e_mag == "Any"
      like_sql << "e_mag ILIKE ? AND "
      values << "%#{e_mag}%"
    end

    unless icp_brasil.nil? and icp_brasil.blank? and icp_brasil == "Any"
      like_sql << "icp_brasil ILIKE ? AND "
      values << "%#{icp_brasil}%"
    end

    unless e_arq.nil? and e_arq.blank? and e_arq == "Any"
      like_sql << "e_arq ILIKE ? AND "
      values << "%#{e_arq}%"
    end

    unless internacionalizable.nil? and internacionalizable.blank? and internacionalizable == "Any"
      like_sql << "internacionalizable ILIKE ? AND "
      values << "%#{internacionalizable}%"
    end

    like_sql = like_sql[0..like_sql.length-5]

    {
      :joins => :community,
      :conditions=>[like_sql, *values]
    }
  }


  def validate_operating_platform
    self.errors.add(:operating_platform, _("can't be blank")) if self.operating_platform.blank? && self.errors.messages[:operating_platform].nil?
  end

  def validate_acronym
    if self.acronym.blank? && self.errors.messages[:acronym].nil?
      self.errors.add(:acronym, _("can't be blank"))
    elsif self.acronym.length > 8 && self.errors.messages[:acronym].nil?
      self.errors.add(:acronym, _("can't have more than 8 characteres"))
    end
  end

  def valid_operating_systems
    self.errors.add(:operating_system, _(": at least one must be filled")) if self.operating_systems.empty?
  end

  def valid_software_info
    self.errors.add(:software_languages, _(": at least one must be filled")) if self.software_languages.empty?
  end

  def valid_databases
    self.errors.add(:software_databases, _(": at least one must be filled")) if self.software_databases.empty?
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
