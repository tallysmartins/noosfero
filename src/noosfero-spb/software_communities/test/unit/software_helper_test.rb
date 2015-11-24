require 'test_helper'

class SoftwareHelperTest < ActiveSupport::TestCase

  include SoftwareCommunitiesPlugin::SoftwareHelper

  should "Create ProgrammingLanguages based on file with languages names" do
    SoftwareCommunitiesPlugin::ProgrammingLanguage.delete_all
    PATH_TO_FILE = "plugins/software_communities/public/static/languages.txt"

    SoftwareCommunitiesPlugin::SoftwareHelper.create_list_with_file(PATH_TO_FILE, SoftwareCommunitiesPlugin::ProgrammingLanguage)

    list = File.open(PATH_TO_FILE, "r")
    count = list.readlines.count
    list.close

    assert(SoftwareCommunitiesPlugin::ProgrammingLanguage.count == count)
  end

  should "return the software template specified in config.yml file" do
    template_community = Community.create!(:name => "Software", :identifier => "software_template", :is_template => true)

    parsed_yaml = {"software_template" => "software_template"}

    SoftwareCommunitiesPlugin::SoftwareHelper.stubs(:software_template_identifier).returns("software_template")

    software_template = SoftwareCommunitiesPlugin::SoftwareHelper.software_template
    assert !software_template.blank?
    assert software_template.is_template
  end

  should "not return the software template if there is not software template" do
    parsed_yaml = {"software_template" => "software_template"}

    SoftwareCommunitiesPlugin::SoftwareHelper.stubs(:software_template_identifier).returns("software_template")

    software_template = SoftwareCommunitiesPlugin::SoftwareHelper.software_template
    assert software_template.blank?

    template_community = Community.create!(:name => "Software", :identifier => "software_template")

    software_template = SoftwareCommunitiesPlugin::SoftwareHelper.software_template
    assert software_template.blank?
  end
end
