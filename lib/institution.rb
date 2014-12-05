class Institution < ActiveRecord::Base

  SEARCH_FILTERS = []
  SEARCH_DISPLAYS = %w[compact]

  def self.default_search_display
    'compact'
  end

  belongs_to :governmental_power
  belongs_to :governmental_sphere
  belongs_to :juridical_nature

  has_and_belongs_to_many :users

  attr_accessible :name, :acronym, :unit_code, :parent_code, :unit_type, 
                  :sub_juridical_nature, :normalization_level, 
                  :version, :cnpj, :type, :governmental_power, :governmental_sphere,
                  :sisp, :juridical_nature, :corporate_name

  validates :name, :presence=>true, :uniqueness=>true

  validates :corporate_name, :presence => true

  before_save :verify_institution_type

  belongs_to :community
  
  scope :search_institution, lambda{ |value|
    where("name ilike ? OR acronym ilike ?", "%#{value}%", "%#{value}%" )
  }

  validate :validate_country, :validate_state, :validate_city, :verify_institution_type, :validate_cnpj, :validate_format_cnpj


  protected

  def verify_institution_type
    valid_institutions_type = ["PublicInstitution", "PrivateInstitution"]

    unless valid_institutions_type.include? self.type
      self.errors.add(:type, _("invalid, only public and private institutions are allowed."))

      return false
    end
    return true
  end

  def validate_country
    if (self.community.blank?) || self.community.country.blank? && self.errors[:country].blank?
      self.errors.add(:country, _("can't be blank"))
      return false
    end
    return true
  end

  def validate_state
    if (self.community.blank?) || self.errors[:state].blank? && self.community.state.blank?
      if self.community.country == "BR"
        self.errors.add(:state, _("can't be blank"))
        return false
      else
        return true
      end
    end
    return true
  end

  def validate_city
    if (self.community.blank?) || self.errors[:city].blank? && self.community.city.blank?
      if self.community.country == "BR"
        self.errors.add(:city, _("can't be blank"))
        return false
      else
        return true
      end
    end
    return true
  end

  def validate_format_cnpj
    return true if !self.community.blank? && self.community.country != "BR"

    format =  /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/

    if !self.cnpj.blank? && format.match(self.cnpj)
      return true
    else
      self.errors.add(:cnpj, _("invalid format"))
      return false
    end
  end

  def validate_cnpj
    if !self.community.blank? && self.community.country == "BR"
      if self.errors[:cnpj].blank? && self.cnpj.blank?
        self.errors.add(:cnpj, _("can't be blank"))
        return false
      else
        return true
      end
    else
      return true
    end
  end
end
