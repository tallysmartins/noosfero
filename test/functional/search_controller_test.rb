require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../../../app/controllers/public/search_controller'
require File.dirname(__FILE__) + '/software_test_helper'

class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase
  include SoftwareTestHelper
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
    fields = software_fields
    software = create_software fields
    software.save

    params = {"type"=>"Software", "query"=>"", "name"=>"debian", "database_description"=>{"id"=>""}, "programming_language"=>{"id"=>""}, "operating_system"=>{"id"=>""}, "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"", "commit"=>"Search"}
    get :communities, params

    assert_includes assigns(:searches)[:communities][:results], software.community
  end

  should "search for software by name" do
    fields = software_fields
    software = create_software fields
    software.save

    params = {"type"=>"Software", "query"=>"", "name"=>"debian", "database_description"=>{"id"=>""}, "programming_language"=>{"id"=>""}, "operating_system"=>{"id"=>""}, "software_categories"=>"", "license_info"=>{"id"=>""}, "e_ping"=>"", "e_mag"=>"", "icp_brasil"=>"", "e_arq"=>"", "internacionalizable"=>"", "commit"=>"Search"}
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

end
