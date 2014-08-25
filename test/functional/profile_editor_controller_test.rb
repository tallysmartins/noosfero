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
    admin = create_user("adminuser").person
    admin.stubs(:has_permission?).returns("true")
    login_as('adminuser')
    @environment.add_admin(admin)
    @environment.save

    @govPower = GovernmentalPower.create(:name => "Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name => "Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

  end

  should "update institution date_modification when edit profile" do
    create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @govPower, @govSphere)

    post :edit, :profile => Institution.last.community.identifier, :profile_data => {:name => "Ministerio da Saude"}, :institution => Institution.last
    
    date = Time.now.day.to_s + "/" + Time.now.month.to_s + "/" + Time.now.year.to_s
    assert_equal date, Institution.last.date_modification
  end

  should "add new institution for user into edit profile" do
    institutions = []
    institutions << create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @govPower, @govSphere)
    institutions << create_public_institution("Nova Instituicao", "NIN", "BR", "GO", "Goiania", @juridical_nature, @govPower, @govSphere)
    user = fast_create(User)
    user.person = fast_create(Person)
    user.person.user = user
    user.save!
    user.person.save!

    params_user = Hash.new
    params_user[:institution_ids] = []
    institutions.each do |institution|
      params_user[:institution_ids] << institution.id
    end

    post :edit, :profile => User.last.person.identifier, :user => params_user

    assert_equal institutions.count, User.last.institutions.count
  end

  should "remove institutions for user into edit profile" do
    user = fast_create(User)
    user.person = fast_create(Person)

    user.institutions << create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @govPower, @govSphere)
    user.institutions << create_public_institution("Nova Instituicao", "NIN", "BR", "GO", "Goiania", @juridical_nature, @govPower, @govSphere)

    user.person.user = user
    user.save!
    user.person.save!

    params_user = Hash.new
    params_user[:institution_ids] = []

    post :edit, :profile => User.last.person.identifier, :user => params_user

    assert_equal 0, User.last.institutions.count
  end

  private

  def create_public_institution name, acronym, country, state, city, juridical_nature,   gov_p, gov_s
    institution_community = fast_create(Community)
    institution_community.name = name
    institution_community.country = country
    institution_community.state = state
    institution_community.city = city
    institution_community.save!

    institution = PublicInstitution.new
    institution.community = institution_community
    institution.name = name
    institution.juridical_nature = juridical_nature
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.save!
    institution
  end

end
