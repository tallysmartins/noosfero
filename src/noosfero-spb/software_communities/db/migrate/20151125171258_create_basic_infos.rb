class CreateBasicInfos < ActiveRecord::Migration
  def up
    link = "http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    SoftwareCommunitiesPlugin::LicenseInfo.create(:version => "CC-GPL-V2", :link => link)

    SoftwareCommunitiesPlugin::SoftwareHelper.create_list_with_file("plugins/software_communities/public/static/languages.txt", SoftwareCommunitiesPlugin::ProgrammingLanguage)

    path_to_file = "plugins/software_communities/public/static/databases.txt"
    SoftwareCommunitiesPlugin::SoftwareHelper.create_list_with_file(path_to_file, SoftwareCommunitiesPlugin::DatabaseDescription)

    path_to_file = "plugins/software_communities/public/static/operating_systems.txt"
    SoftwareCommunitiesPlugin::SoftwareHelper.create_list_with_file(path_to_file, SoftwareCommunitiesPlugin::OperatingSystemName)
  end

  def down
  end
end
