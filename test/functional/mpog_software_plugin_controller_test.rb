require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_controller'

class MpogSoftwarePluginController; def rescue_action(e) raise e end; end

class MpogSoftwarePluginControllerTest < ActionController::TestCase

  def setup
    admin = create_user("adminuser").person
    admin.stubs(:has_permission?).returns("true")

    @environment = Environment.default
    @environment.enabled_plugins = ['MpogSoftwarePlugin']
    @environment.add_admin(admin)
    @environment.save

    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")
    @response = ActionController::TestResponse.new

    @institution_list = []
    @institution_list << create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @govPower, @govSphere, "12.345.678/9012-45")
    @institution_list << create_public_institution("Tribunal Regional da Uniao", "TRU", "BR", "DF", "Brasilia", @juridical_nature, @govPower, @govSphere, "12.345.678/9012-90")
  end

  should "Search for institution with acronym" do
    xhr :get, :get_institutions, :query=>"TRU"

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert_equal "Tribunal Regional da Uniao", json_response[0]["value"]
  end

  should "Search for institution with name" do
    xhr :get, :get_institutions, :query=>"Minis"

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert_equal "Ministerio Publico da Uniao", json_response[0]["value"]
  end

  should "search with name or acronym and return a list with institutions" do
    xhr :get, :get_institutions, :query=>"uni"

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert_equal "Ministerio Publico da Uniao", json_response[0]["value"]
    assert_equal "Tribunal Regional da Uniao", json_response[1]["value"]
  end

  should "method create_institution return the html for modal" do
    xhr :get, :create_institution
    assert_template 'create_institution'
  end

  should "create new institution with ajax without acronym" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = generate_form_fields "foo bar", "BR", "DF", "Brasilia", "12.234.567/8900-10", "PublicInstitution"
    fields[:institutions][:governmental_power] = @govPower.id
    fields[:institutions][:governmental_sphere] = @govSphere.id
    fields[:institutions][:juridical_nature] = @juridical_nature.id

    xhr :get, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert json_response["success"]
  end

  should "not create a institution that already exists" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = generate_form_fields "Ministerio Publico da Uniao", "BR", "DF", "Brasilia", "12.234.567/8900-10", "PublicInstitution"
    fields[:institutions][:governmental_power] = @govPower.id
    fields[:institutions][:governmental_sphere] = @govSphere.id
    fields[:institutions][:juridical_nature] = @juridical_nature.id

    xhr :get, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert !json_response["success"]
  end

  should "not create a institution without cnpj" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = generate_form_fields "Some Private Institution", "BR", "DF", "Brasilia", "", "PrivateInstitution"
    fields[:institutions][:acronym] = "SPI"

    xhr :get, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert !json_response["success"]
  end

  should "verify if institution name already exists" do
    xhr :get, :institution_already_exists, :name=>"Ministerio Publico da Uniao"
    assert_equal "true", @response.body

    xhr :get, :institution_already_exists, :name=>"Another name here"
    assert_equal "false", @response.body
  end

  should "response as XML to export softwares" do
    get :download, :format => 'xml'
    assert_equal 'text/xml', @response.content_type
  end

  should "response as CSV to export softwares" do
    get :download, :format => 'csv'
    assert_equal 'text/csv', @response.content_type
    assert_equal "name;acronym;demonstration_url;e_arq;e_mag;e_ping;features;icp_brasil;objectives;operating_platform\n", @response.body
  end

  should "hide registration incomplete message" do
    xhr :get, :hide_registration_incomplete_percentage, :hide=>true
    assert_equal "true", @response.body
  end

  should "not hide registration incomplete message" do
    xhr :get, :hide_registration_incomplete_percentage, :hide=>false
    assert_equal "false", @response.body
  end

  should "Create new institution with method post" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = generate_form_fields "Some Private Institution", "BR", "DF", "Brasilia", "12.345.567/8900-10", "PrivateInstitution"
    fields[:institutions][:acronym] = "SPI"

    post :new_institution, fields

    assert_redirected_to(controller: "admin_panel", action: "index")
  end

  should "not create new institution with method post without cnpj" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = generate_form_fields "Some Private Institution", "BR", "DF", "Brasilia", "", "PrivateInstitution"
    fields[:institutions][:acronym] = "SPI"

    post :new_institution, fields

    assert_redirected_to(controller: "mpog_software_plugin", action: "create_institution_admin")
  end

  private

  def generate_form_fields name, country, state, city, cnpj, type
    fields = {
      :community => {
        :name => name,
        :country => country,
        :state => state,
        :city => city
      },
      :institutions => {
        :cnpj=> cnpj,
        :type => type,
        :acronym => "",
        :governmental_power => "",
        :governmental_sphere => "",
        :juridical_nature => ""
      }
    }
    fields
  end

  def create_public_institution name, acronym, country, state, city, juridical_nature, gov_p, gov_s, cnpj
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
    institution.cnpj = cnpj
    institution.save!
    institution
  end

end
