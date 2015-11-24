class SoftwareCommunitiesPlugin::SoftwareLanguage < ActiveRecord::Base
  attr_accessible :version

  belongs_to :software_info, :class => "SoftwareCommunitiesPlugin::SoftwareInfo"
  belongs_to :programming_language, :class => "SoftwareCommunitiesPlugin::ProgrammingLanguage"

  validates_length_of(
    :version,
    :maximum => 20,
    :too_long => _("Software language is too long (maximum is 20 characters)")
  )

  validates_presence_of :version, :programming_language
end
