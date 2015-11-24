class SoftwareCommunitiesPlugin::DatabaseDescription < ActiveRecord::Base

  SEARCHABLE_SOFTWARE_FIELDS = {
    :name => 1
  }

  attr_accessible :name

  has_many :software_databases, :class_name => 'SoftwareCommunitiesPlugin::SoftwareDatabase'
  has_many :software_infos, :through => :software_databases, :class_name => 'SoftwareCommunitiesPlugin::SoftwareInfo'

  validates_presence_of :name
  validates_uniqueness_of :name

end
