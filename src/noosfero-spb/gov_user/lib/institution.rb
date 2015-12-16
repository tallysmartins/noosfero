class Institution < ActiveRecord::Base
  has_many :comments

  SEARCH_FILTERS = {
    :order => %w[],
    :display => %w[compact]
  }

  CNPJ_FORMAT = /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/

  def self.default_search_display
    'compact'
  end

  belongs_to :governmental_power
  belongs_to :governmental_sphere
  belongs_to :juridical_nature

  has_and_belongs_to_many :users

  attr_accessible :name, :acronym, :unit_code, :parent_code, :unit_type,
                  :sub_juridical_nature, :normalization_level,
                  :version, :cnpj, :type, :governmental_power,
                  :governmental_sphere, :sisp, :juridical_nature,
                  :corporate_name, :siorg_code, :community

  validates :name, :presence=>true, :uniqueness=>true
  validates :cnpj, :length=>{maximum: 18}

  before_save :verify_institution_type

  belongs_to :community

  scope :search_institution, lambda{ |value|
    where("name ilike ? OR acronym ilike ?", "%#{value}%", "%#{value}%" )
  }

  validate :validate_country, :validate_state, :validate_city,
           :verify_institution_type


  def has_accepted_rating? user_rating
    rating_ids = OrganizationRating.where(institution_id: self.id, organization_id: user_rating.organization_id).map(&:id)
    finished_tasks = CreateOrganizationRatingComment.finished.select {|task| rating_ids.include?(task.organization_rating_id)}
    pending_tasks = CreateOrganizationRatingComment.pending.select{|c| c.organization_rating_id == user_rating.id}

    !finished_tasks.empty? && !pending_tasks.empty?
  end

  protected

  def verify_institution_type
    valid_institutions_type = ["PublicInstitution", "PrivateInstitution"]

    unless valid_institutions_type.include? self.type
      self.errors.add(
        :type,
        _("invalid, only public and private institutions are allowed.")
      )

      return false
    end

    return true
  end

  def validate_country
    unless self.community.blank?
      if self.community.country.blank? && self.errors[:country].blank?
        self.errors.add(:country, _("can't be blank"))
        return false
      end
    end

    return true
  end

  def validate_state
    unless self.community.blank?
      if self.community.country == "BR" &&
        (self.community.state.blank? || self.community.state == "-1") &&
        self.errors[:state].blank?

        self.errors.add(:state, _("can't be blank"))
        return false
      end
    end

    return true
  end

  def validate_city
    unless self.community.blank?
      if self.community.country == "BR" && self.community.city.blank? &&
        self.errors[:city].blank?

        self.errors.add(:city, _("can't be blank"))
        return false
      end
    end

    return true
  end
end
