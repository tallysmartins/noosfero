require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../../../app/controllers/my_profile/profile_editor_controller'

class ProfileEditorController; def rescue_action(e) raise e end; end

class ProfileEditorControllerTest < ActionController::TestCase

  def setup
    @controller = ProfileEditorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('default_user').person
    Environment.default.affiliate(@profile, [Environment::Roles.admin(Environment.default.id)] + Profile::Roles.all_roles(Environment.default.id))
    @environment = Environment.default
    @environment.enabled_plugins = ['MpogSoftwarePlugin']

    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")

    admin = create_user("adminuser").person
    admin.stubs(:has_permission?).returns("true")
    login_as('adminuser')

    @environment.add_admin(admin)
    @environment.save
  end

  should "update institution date_modification in your creation" do
    institution = create_public_institution("Ministerio Publico da Uniao", "MPU", @govPower, @govSphere)
    institution.date_modification = "Invalid Date"

    post :edit, :profile => Institution.last.community.identifier, :profile_data => {:name => "Ministerio da Saude"}, :institution => institution
    
    date = Time.now.day.to_s + "/" + Time.now.month.to_s + "/" + Time.now.year.to_s
    assert_equal date, Institution.last.date_modification
  end

  private

  def create_public_institution name, acronym, gov_p, gov_s
    institution_community = fast_create(Community)
    institution_community.name = name

    institution = PublicInstitution.new
    institution.community = institution_community
    institution.name = name
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.save!
    institution
  end

end