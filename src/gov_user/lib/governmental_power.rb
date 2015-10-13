class GovernmentalPower < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence=>true, :uniqueness=>true
  has_many :institutions

  def public_institutions
    Institution.where(
      :type=>"PublicInstitution",
      :governmental_power_id=>self.id
    )
  end
end
