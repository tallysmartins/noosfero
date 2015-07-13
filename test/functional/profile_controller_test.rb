require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../helpers/software_test_helper'
require(
  File.expand_path(File.dirname(__FILE__)) +
  '/../../../../app/controllers/public/profile_controller'
)

class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < ActionController::TestCase
include SoftwareTestHelper
  def setup
    @controller =CommunitiesRatingsPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('default_user').person

    Environment.default.affiliate(
      @profile,
      [Environment::Roles.admin(Environment.default.id)] +
      Profile::Roles.all_roles(Environment.default.id)
    )

    LicenseInfo.create(
      :version=>"CC-GPL-V2",
      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    )

    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin', 'CommunitiesRatingsPlugin']
    admin = create_user("adminuser").person
    admin.stubs(:has_permission?).returns("true")
    login_as('adminuser')
    @environment.add_admin(admin)
    @environment.save
  end

  should "dispach additional comment fields to Softwares" do
    @hash_list = software_fields
    software = create_software(@hash_list)

    get :new_rating , profile: software.community.identifier
    assert_template :new_rating
    assert_match(/Aditional informations/, @response.body)
  end

  should "NOT dispach additional comment fields only to Softwares" do
    community = fast_create(Community)

    get :new_rating , profile: community.identifier
    assert_template :new_rating
    assert_not_match(/Aditional informations/, @response.body)
  end

end