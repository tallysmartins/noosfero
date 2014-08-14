class Institution < ActiveRecord::Base
  belongs_to :governmental_power
  belongs_to :governmental_sphere
  belongs_to :juridical_nature

  has_and_belongs_to_many :users

  attr_accessible :name, :acronym, :unit_code, :parent_code, :unit_type, 
                  :sub_juridical_nature, :normalization_level, 
                  :version, :cnpj, :type, :governmental_power, :governmental_sphere,
                  :sisp, :juridical_nature

  validates :name, :presence=>true, :uniqueness=>true

  before_save :verify_institution_type

  belongs_to :community

  scope :search_institution, lambda{ |value|
    where("name ilike ? OR acronym ilike ?", "%#{value}%", "%#{value}%" )
  }

  protected

  def verify_institution_type
    valid_institutions_type = ["PublicInstitution", "PrivateInstitution"]

    unless valid_institutions_type.include? self.type
      self.errors.add(:type, _("invalid, only public and private institutions are allowed."))
      false
    end
  end
end
