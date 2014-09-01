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


  # should "search for software by name" do
  #   software = create_software("software")

  #   get :communities, :type => "Software", :query => "", :name => "software", :database_description => {:id => ""}, :programming_language => {:id=>""}, :operating_system => {:id => ""}, :controlled_vocabulary => "", :license_info => {:id => ""}, :e_ping => "", :e_mag => "", :icp_brasil => "", :e_arq => "", :internacionalizable => ""

  #   assert_includes assigns(:searches)[:communities][:results], software.community
  # end

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
    software_info.save!

    community.save!

    software_info
  end
  
end
