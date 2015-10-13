require File.dirname(__FILE__) + '/../../../../test/test_helper'
require(
  File.dirname(__FILE__) +
  '/../../../../app/controllers/my_profile/profile_editor_controller'
)

class ProfileEditorController; def rescue_action(e) raise e end; end

class ProfileEditorControllerTest < ActionController::TestCase

  def setup
    @controller = ProfileEditorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('default_user').person

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
    software = create_software_info("Test Software")

    post :edit, :profile => software.community.identifier

    assert_redirected_to :controller => 'profile_editor', :action => 'edit_software_community'
  end


  protected

  def create_basic_user
    user = fast_create(User)
    user.person = fast_create(Person)
    user.person.user = user
    user.save!
    user.person.save!
    user
  end

  def create_community name
    community = fast_create(Community)
    community.name = name
    community.save
    community
  end

  def create_software_info name, finality = "something", acronym = ""
    community = create_community(name)
    software_info = SoftwareInfo.new
    software_info.community = community
    software_info.finality = finality
    software_info.acronym = acronym
    software_info.public_software = true
    software_info.save
    software_info
  end

end
