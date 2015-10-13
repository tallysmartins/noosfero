require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/software_communities_plugin_controller'

class SoftwareCommunitiesPluginController; def rescue_action(e) raise e end; end

class SoftwareCommunitiesPluginControllerTest < ActionController::TestCase
  def setup
    @admin = create_user("adminuser").person
    @admin.stubs(:has_permission?).returns("true")
    @controller.stubs(:current_user).returns(@admin.user)

    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.add_admin(@admin)
    @environment.save

    LicenseInfo.create(:version=>"CC-GPL-V2", :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt")
    LicenseInfo.create(:version=>"Academic Free License 3.0 (AFL-3.0)", :link=>"http://www.openfoundry.org/en/licenses/753-academic-free-license-version-30-afl")
    LicenseInfo.create(:version=>"Apache License 2.0 (Apache-2.0)", :link=>"http://www.apache.org/licenses/LICENSE-2.0")
    LicenseInfo.create(:version=>'BSD 2-Clause "Simplified" or "FreeBSD" License (BSD-2-Clause)', :link=>"http://opensource.org/licenses/BSD-2-Clause")

    ProgrammingLanguage.create(:name =>"Java")
    ProgrammingLanguage.create(:name =>"Ruby")
    ProgrammingLanguage.create(:name =>"C")
    ProgrammingLanguage.create(:name =>"C++")
    DatabaseDescription.create(:name => "PostgreSQL")
    DatabaseDescription.create(:name => "MySQL")
    DatabaseDescription.create(:name => "MongoDB")
    DatabaseDescription.create(:name => "Oracle")
    OperatingSystemName.create(:name=>"Debian")

    @response = ActionController::TestResponse.new
  end

  should 'return the licenses datas' do
    xhr :get, :get_license_data, :query => ""

    licenses = JSON.parse(@response.body)

    assert_equal 4, licenses.count
  end

  should 'return licenses that has Free on their version name' do
    xhr :get, :get_license_data, :query => "Free"

    licenses = JSON.parse(@response.body)

    assert_equal 2, licenses.count
  end

  should 'return no licenses that has Common on their version name' do
    xhr :get, :get_license_data, :query => "Common"

    licenses = JSON.parse(@response.body)

    assert_equal 0, licenses.count
  end

  should 'render block template' do
    xhr :get, :get_block_template

    assert_tag :tag => 'input', :attributes => { :class => "block_download_name" }
    assert_tag :tag => 'input', :attributes => { :class => "block_download_link" }
    assert_tag :tag => 'input', :attributes => { :class => "block_download_software_description" }
    assert_tag :tag => 'input', :attributes => { :class => "block_download_minimum_requirements" }
    assert_tag :tag => 'input', :attributes => { :class => "block_download_size" }
  end

  should 'return the programming languages' do
    xhr :get, :get_field_data, :query => "", :field => "software_language"

    languages = JSON.parse(@response.body)

    assert_equal 4, languages.count
  end

  should 'return the programming languages that has C on their name' do
    xhr :get, :get_field_data, :query => "C", :field => "software_language"

    languages = JSON.parse(@response.body)

    assert_equal 2, languages.count
  end

  should 'dont return the programming languages that has HTML on their name' do
    xhr :get, :get_field_data, :query => "HTML", :field => "software_language"

    languages = JSON.parse(@response.body)

    assert_equal 1, languages.count
  end

  should 'return the databases' do
    xhr :get, :get_field_data, :query => "", :field => "software_database"

    databases = JSON.parse(@response.body)

    assert_equal 4, databases.count
  end

  should 'return the databases that has SQL on their name' do
    xhr :get, :get_field_data, :query => "SQL", :field => "software_database"

    databases = JSON.parse(@response.body)

    assert_equal 3, databases.count
  end

  should 'dont return the database that has  on their name' do
    xhr :get, :get_field_data, :query => "Cache", :field => "software_database"

    databases = JSON.parse(@response.body)

    assert_equal 1, databases.count
  end
end
