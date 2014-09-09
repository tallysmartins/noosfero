require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../../../app/controllers/public/search_controller'

class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase

  def setup
    environment = Environment.default
    environment.enabled_plugins = ['MpogSoftwarePlugin']
    environment.save

    @controller = SearchController.new
    @request = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(:false)
    @response = ActionController::TestResponse.new

    LicenseInfo.create(:version=>"GPL-2", :link =>"www.gpl2.com")
    ProgrammingLanguage.create(:name=>"C++")
    DatabaseDescription.create(:name => "Oracle")
    OperatingSystemName.create(:name=>"Debian")

    operating_system = OperatingSystem.new(version: '1.0')
    operating_system.operating_system_name = OperatingSystemName.last
    operating_system.save!

    software_language = SoftwareLanguage.new(version: "1.0", operating_system: "windows")
    software_language.programming_language = ProgrammingLanguage.last
    software_language.save!

    software_database = SoftwareDatabase.new(version: "1.0", operating_system: "windows")
    software_database.database_description = DatabaseDescription.last
    software_database.save!

  end

  should "search for people by identifier" do
    p1 = create_user("user 1", "DF", "Gama", "user_1@user.com").person

    get :people, :query => "user-1"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for people by name" do
    p1 = create_user("user_1", "DF", "Gama", "user_1@user.com").person

    get :people, :query => "user_1"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for people by state" do
    p1 = create_user("user_1", "DF", "Gama", "user_1@user.com").person

    get :people, :state => "DF"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for people by city" do
    p1 = create_user("user_1", "DF", "Gama", "user_1@user.com").person

    get :people, :city => "Gama"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for people by email" do
    p1 = create_user("user_1", "DF", "Gama", "user_1@user.com").person

    get :people, :email => "user_1@user.com"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for people by email and state" do
    p1 = create_user("user_1", "DF", "Gama", "user_1@user.com").person

    get :people, :email => "user_1@user.com", :state => "DF"

    assert_includes assigns(:searches)[:people][:results], p1
  end

  should "search for software by identifier" do
    software = create_software("beautiful os")

    params = {"type"=>"Software", "query"=>"", "name"=>"beautiful-os", "database_description"=>{"id"=>""}, "programming_language"=>{"id"=>""}, "operating_system"=>{"id"=>""}, "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"", "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by name" do
    software = create_software("beautiful")

    params = {"type"=>"Software", "query"=>"", "name"=>"beautiful", "database_description"=>{"id"=>""}, "programming_language"=>{"id"=>""}, "operating_system"=>{"id"=>""}, "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"", "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by database" do
    software = create_software("beautiful")
    software.software_databases.clear()
    software.software_databases << SoftwareDatabase.last
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"",
          "database_description"=>{"id"=>SoftwareDatabase.last.database_description.id},
      "programming_language"=>{"id"=>""}, "operating_system"=>{"id"=>""}, "software_categories"=>"",
      "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by programming language" do
    software = create_software("beautiful")
    software.software_languages.clear()
    software.software_languages << SoftwareLanguage.last
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>SoftwareLanguage.last.programming_language.id},
      "operating_system"=>{"id"=>""}, "software_categories"=>"",
      "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by operating system" do
    software = create_software("beautiful")
    software.operating_systems.clear()
    software.operating_systems << OperatingSystem.last
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>OperatingSystem.last.id},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by controlled vocabulary" do
    software = create_software("beautiful")
    software.software_categories.habitation = true
    software.software_categories.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"habitation", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by license info" do
    software = create_software("beautiful")
    software.license_info = LicenseInfo.last
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>LicenseInfo.last.id}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end


  should "search for software by e_mag" do
    software = create_software("beautiful")
    software.e_mag = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"true", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end


  should "search for software by e_ping" do
    software = create_software("beautiful")
    software.e_ping = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"true", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end


  should "search for software by icp_brasil" do
    software = create_software("beautiful")
    software.icp_brasil = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"true", "e_arq"=>"", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by e_arq" do
    software = create_software("beautiful")
    software.e_arq = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"true", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by internacionalizable" do
    software = create_software("beautiful")
    software.intern = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"true",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search by e_arq and e_ping" do
    software = create_software("beautiful")
    software.e_arq = true
    software.e_ping = true
    software.save!

    params = {"type"=>"Software", "query"=>"", "name"=>"", "database_description"=>{"id"=>""},
      "programming_language"=>{"id"=>""},
      "operating_system"=>{"id"=>""},
      "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"true", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"true", "internacionalizable"=>"",
      "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  protected

  def create_user name, state, city, email
  	user = fast_create(User)
  	user.person = fast_create(Person)
  	user.person.state = state
  	user.person.city = city
  	user.person.email = email
  	user.save!
  	user.person.save!
  	user
  end

  def create_software name
  	community = Community.create(:name => name)    
    software_info = SoftwareInfo::new(:acronym=>"SFT", :operating_platform=>"windows")
    software_info.community = community
    software_info.software_languages << SoftwareLanguage.last
    software_info.software_databases << SoftwareDatabase.last
    software_info.operating_systems << OperatingSystem.last
    software_info.license_info = LicenseInfo.last


    sc = SoftwareCategories.new()
    sc.attributes.each do |key|
      if(key.first == 'id' || key.first == 'software_info_id')
        next
      end
      sc.update_attribute(key.first, false)
    end
    sc.save!

    software_info.software_categories = sc

    software_info.save!

    community.save!

    software_info
  end
  
end
