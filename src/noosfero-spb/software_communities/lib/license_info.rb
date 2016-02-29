class LicenseInfo < ActiveRecord::Base
  attr_accessible :version, :link

  validates_presence_of :version

  has_many :software_info

  scope :without_another, lambda { where("version != 'Another'") }
end
