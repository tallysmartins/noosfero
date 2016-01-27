require File.dirname(__FILE__) + '/../helpers/software_test_helper'
require 'test_helper'
require(
  File.dirname(__FILE__) +
  '/../../../../app/controllers/my_profile/profile_editor_controller'
)

class ProfileEditorController; def rescue_action(e) raise e end; end

class ProfileEditorControllerTest < ActionController::TestCase
  include SoftwareTestHelper
  def setup
    @controller = ProfileEditorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('default_user').person

    LicenseInfo.create(
      :version=>"CC-GPL-V2",
      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    )

    Environment.default.affiliate(
      @profile,
      [Environment::Roles.admin(Environment.default.id)] +
      Profile::Roles.all_roles(Environment.default.id)
    )

    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    admin = create_user("adminuser").person
    admin.stubs(:has_permission?).returns("true")
    login_as('adminuser')
    @environment.add_admin(admin)
    @environment.save
  end

  should "redirect to edit_software_community on edit community of software" do
    software = create_software(software_fields)
    post :edit, :profile => software.community.identifier
    assert_redirected_to :controller => 'profile_editor', :action => 'edit_software_community'
  end
end
