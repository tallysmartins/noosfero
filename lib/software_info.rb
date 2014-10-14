class SoftwareInfo < ActiveRecord::Base
  attr_accessible :e_mag, :icp_brasil, :intern, :e_ping, :e_arq, :operating_platform, :demonstration_url, :acronym, :objectives, :features, :license_infos_id, :community_id, :finality, :repository_link

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

  # used on find_by_contents
  scope :like_search, lambda{ |name|
    joins(:community).where("name ilike ?", "%#{name}%")
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

    unless database_description_id.blank?
      like_sql << "software_databases.database_description_id = ? AND "
      values << "#{database_description_id}"
    end

    unless programming_language_id.blank?
      like_sql << "software_languages.programming_language_id = ? AND "
      values << "#{programming_language_id}"
    end

    unless operating_system_name_id.blank?
      like_sql << "operating_systems.operating_system_name_id = ? AND "
      values << "#{operating_system_name_id}"
    end

    unless license_info_id.blank?
      like_sql << "license_info_id = ? AND "
      values << "#{license_info_id}"
    end

    unless internacionalizable.blank?
      like_sql << "intern = ? AND "
      values << "#{internacionalizable}"
    end

    unless icp_brasil.blank?
      like_sql << "icp_brasil = ? AND "
      values << "#{icp_brasil}"
    end

    unless e_ping.blank?
      like_sql << "e_ping = ? AND "
      values << "#{e_ping}"
    end

    unless e_mag.blank?
      like_sql << "e_mag = ? AND "
      values << "#{e_mag}"
    end

    unless e_arq.blank?
      like_sql << "e_arq = ? AND "
      values << "#{e_arq}"
    end

    unless software_categories.blank?
      software_categories = software_categories.gsub(' ', '').underscore
      like_sql << "software_categories.#{software_categories} = ? AND "
      values << "true"
    end

    like_sql = like_sql[0..like_sql.length-5]

    {
      :joins => [:community, :software_databases, :software_languages, 
        :operating_systems, :software_categories],
      :conditions=>[like_sql, *values]
    }
  }

  def validate_operating_platform
    self.errors.add(:operating_platform, _("can't be blank")) if self.operating_platform.blank? && self.errors.messages[:operating_platform].nil?
  end

  def validate_acronym
    self.acronym = "" if self.acronym.nil?

    if self.acronym.length > 10 && self.errors.messages[:acronym].nil?
      self.errors.add(:acronym, _("can't have more than 10 characteres"))
    elsif self.acronym.match(/\s+/)
      self.errors.add(:acronym, _("can't have whitespaces"))
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
