require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'
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

    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

    @institution_list = []
    @institution_list << InstitutionTestHelper.create_public_institution(
      "Ministerio Publico da Uniao",
      "MPU",
      "BR",
      "DF",
      "Gama",
      @juridical_nature,
      @govPower,
      @govSphere,
      "12.345.678/9012-45"
    )

    @institution_list << InstitutionTestHelper.create_public_institution(
      "Tribunal Regional da Uniao",
      "TRU",
      "BR",
      "DF",
      "Brasilia",
      @juridical_nature,
      @govPower,
      @govSphere,
      "12.345.678/9012-90"
    )
  end

  should "add new institution for user into edit profile" do
    user = create_basic_user

    params_user = Hash.new
    params_user[:institution_ids] = []

    @institution_list.each do |institution|
      params_user[:institution_ids] << institution.id
    end

    post :edit, :profile => User.last.person.identifier, :user => params_user

    assert_equal @institution_list.count, User.last.institutions.count
  end

  should "remove institutions for user into edit profile" do
    user = create_basic_user

    @institution_list.each do |institution|
      user.institutions << institution
    end
    user.save!

    params_user = Hash.new
    params_user[:institution_ids] = []

    assert_equal @institution_list.count, User.last.institutions.count

    post :edit, :profile => User.last.person.identifier, :user => params_user

    assert_equal 0, User.last.institutions.count
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
end
