require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'
require File.dirname(__FILE__) + '/../../controllers/software_communities_plugin_controller'

class SoftwareCommunitiesPluginController; def rescue_action(e) raise e end; end

class SoftwareCommunitiesPluginControllerTest < ActionController::TestCase

  def setup
    @admin = create_user("adminuser").person
    @admin.stubs(:has_permission?).returns("true")
    @controller.stubs(:current_user).returns(@admin.user)

    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.add_admin(@admin)
    @environment.save

    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")
    @response = ActionController::TestResponse.new

    @institution_list = []
    @institution_list << InstitutionTestHelper.create_public_institution(
                          "Ministerio Publico da Uniao",
                          "MPU",
                          "BR",
                          "DF",
                          "Gama",
                          @juridical_nature,
                          @gov_power,
                          @gov_sphere,
                          "12.345.678/9012-45"
                        )
    @institution_list << InstitutionTestHelper.create_public_institution(
                          "Tribunal Regional da Uniao",
                          "TRU",
                          "BR",
                          "DF",
                          "Brasilia",
                          @juridical_nature,
                          @gov_power,
                          @gov_sphere,
                          "12.345.678/9012-90"
                        )
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
    @controller.stubs(:current_user).returns(@admin.user)
    xhr :get, :create_institution
    assert_template 'create_institution'
  end

  should "create new institution with ajax without acronym" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
              "foo bar",
              "BR",
              "DF",
              "Brasilia",
              "12.234.567/8900-10",
              "PublicInstitution"
            )
    fields[:institutions][:governmental_power] = @gov_power.id
    fields[:institutions][:governmental_sphere] = @gov_sphere.id
    fields[:institutions][:juridical_nature] = @juridical_nature.id

    xhr :get, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert json_response["success"]
  end

  should "not create a institution that already exists" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
              "Ministerio Publico da Uniao",
              "BR",
              "DF",
              "Brasilia",
              "12.234.567/8900-10",
              "PublicInstitution"
            )
    fields[:institutions][:governmental_power] = @gov_power.id
    fields[:institutions][:governmental_sphere] = @gov_sphere.id
    fields[:institutions][:juridical_nature] = @juridical_nature.id

    xhr :get, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)

    assert !json_response["success"]
  end

  should "not create a institution without cnpj" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
              "Some Private Institution",
              "BR",
              "DF",
              "Brasilia",
              "",
              "PrivateInstitution"
            )
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

    fields = InstitutionTestHelper.generate_form_fields(
              "Some Private Institution",
              "BR",
              "DF",
              "Brasilia",
              "12.345.567/8900-10",
              "PrivateInstitution"
            )
    fields[:institutions][:acronym] = "SPI"

    post :new_institution, fields

    assert_redirected_to(controller: "admin_panel", action: "index")
  end

  should "not create new institution with method post without cnpj" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
              "Some Private Institution",
              "BR",
              "DF",
              "Brasilia",
              "",
              "PrivateInstitution"
            )
    fields[:institutions][:acronym] = "SPI"

    post :new_institution, fields

    assert_redirected_to(controller: "software_communities_plugin", action: "create_institution_admin")
  end

  should "Create foreign institution without city, state and cnpj by post" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
                "Foreign institution",
                "AZ",
                "",
                "",
                "",
                "PrivateInstitution"
              )
    fields[:institutions][:acronym] = "FI"

    post :new_institution, fields

    assert_redirected_to(controller: "admin_panel", action: "index")
  end

  should "Create foreign institution without city, state and cnpj by ajax" do
    @controller.stubs(:verify_recaptcha).returns(true)

    fields = InstitutionTestHelper.generate_form_fields(
              "Foreign institution",
              "AZ",
              "",
              "",
              "",
              "PrivateInstitution"
            )
    fields[:institutions][:acronym] = "FI"

    xhr :post, :new_institution, fields

    json_response = ActiveSupport::JSON.decode(@response.body)
    assert json_response["success"]
  end

  should "add environment admins to institution when created via admin panel" do
    @controller.stubs(:verify_recaptcha).returns(true)
    admin2 = create_user("another_admin").person
    admin2.stubs(:has_permission?).returns("true")
    @environment.add_admin(admin2)
    @environment.save

    fields = InstitutionTestHelper.generate_form_fields(
              "Private Institution",
              "BR",
              "DF",
              "Brasilia",
              "12.323.557/8900-10",
              "PrivateInstitution"
            )
    fields[:institutions][:acronym] = "PI"
    fields[:edit_institution_page] = false
    post :new_institution, fields

    assert(Institution.last.community.admins.include?(admin2) )
  end

end