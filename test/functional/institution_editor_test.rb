require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_controller'


class InstitutionEditorTest < ActionController::TestCase

  def setup
    @controller = ProfileEditorController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @environment = Environment.default
    @environment.enabled_plugins = ['MpogSoftwarePlugin']
    @environment.save
  
    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

   
    @institution_list = []
    @institution_list << create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @govPower, @govSphere)
    @institution_list << create_public_institution("Tribunal Regional da Uniao", "TRU", "BR", "DF", "Brasilia", @juridical_nature, @govPower, @govSphere)
  end


 should ' enable edition of sisp field for enviroment admin' do
   admin = create_user("adminuser").person
   admin.stubs(:has_permission?).returns("true")
   login_as('adminuser')
   @environment.add_admin(admin)
   get :edit, :profile => @institution_list[0].community.identifier, :id => @institution_list[0].community.id
   assert_tag :tag => 'span', :descendant => {:tag  => "input", :attributes => { :type => 'radio', :name => "institution[sisp]"}}
 end

  should 'enable only visulization of sisp field for institution admin' do
    ze = create_user("ze").person
    login_as('ze')
    @institution_list[0].community.add_admin(ze)
    get :edit, :profile => @institution_list[0].community.identifier, :id => @institution_list[0].community.id
    assert_tag :tag => 'span', :descendant => {:tag  => "label", :attributes => {:for => "SISP"}}
  end


  private

  def create_public_institution name, acronym, country, state, city, juridical_nature, gov_p, gov_s
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
    institution.sisp = false
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.save!

    institution
  end

end
