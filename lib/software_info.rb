class SoftwareInfo < ActiveRecord::Base
  attr_accessible :e_mag, :icp_brasil, :intern, :e_ping, :e_arq, :operating_platform, :demonstration_url, :acronym, :objectives, :features, :license_infos_id, :community_id, :finality, :repository_link, :public_software, :first_edit

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

    like_sql = like_sql[0..like_sql.length-5]

    {
      :joins => [:community],
      :conditions=>[like_sql, *values]
    }
  }

  def validate_name_lenght
    if self.community.name.size > 100
      self.errors.add(:base, _("Name is too long (maximum is %{count} characters)"))
      false
    end
    true
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
