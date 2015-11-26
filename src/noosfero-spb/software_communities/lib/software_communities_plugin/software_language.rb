class SoftwareCommunitiesPlugin::SoftwareLanguage < ActiveRecord::Base

  belongs_to :software_info, :class_name  => "SoftwareCommunitiesPlugin::SoftwareInfo"
  belongs_to :programming_language, :class_name => "SoftwareCommunitiesPlugin::ProgrammingLanguage"

  attr_accessible :version

  validates_length_of(
    :version,
    :maximum => 20,
    :too_long => _("Software language is too long (maximum is 20 characters)")
  )

  validates_presence_of :version, :programming_language
end
