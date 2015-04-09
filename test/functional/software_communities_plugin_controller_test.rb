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
end
