class SoftwareCommunitiesPlugin::OperatingSystemName < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :operating_systems, :class_name => 'SoftwareCommunitiesPlugin::OperatingSystem'
  has_many :software_infos, :through => :operating_systems, :class_name => 'SoftwareCommunitiesPlugin::SoftwareInfo'

end
