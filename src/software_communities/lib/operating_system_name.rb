class OperatingSystemName < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :operating_systems
  has_many :software_infos, :through => :operating_systems

end
