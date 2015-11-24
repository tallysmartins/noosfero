class SoftwareCommunitiesPlugin::ProgrammingLanguage < ActiveRecord::Base

  SEARCHABLE_SOFTWARE_FIELDS = {
    :name => 1
  }

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :software_languages, :class_name => 'SoftwareCommunitiesPlugin::SoftwareLanguage'
  has_many :software_infos, :through => :software_languages, :class_name => 'SoftwareCommunitiesPlugin::SoftwareInfo'

end
