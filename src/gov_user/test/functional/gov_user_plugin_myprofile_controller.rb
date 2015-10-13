require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'
require(
File.dirname(__FILE__) +
'/../../controllers/gov_user_plugin_myprofile_controller'
)

class GovUserPluginMyprofileController; def rescue_action(e) raise e end;
end

class GovUserPluginMyprofileControllerTest < ActionController::TestCase
  def setup
    @controller = GovUserPluginMyprofileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @person = create_user('person').person
    @offer = create_user('Angela Silva')
    @offer_1 = create_user('Ana de Souza')
    @offer_2 = create_user('Angelo Roberto')

    login_as(@person.user_login)
    @environment = Environment.default
    @environment.enable_plugin('GovUserPlugin')
    @environment.save!
  end
  should "user edit its community institution" do
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juridical_nature = JuridicalNature.create(:name => "Autarquia")

    institution = InstitutionTestHelper.create_public_institution(
      "Ministerio Publico da Uniao",
      "MPU",
      "BR",
      "DF",
      "Gama",
      juridical_nature,
      govPower,
      govSphere,
      "12.345.678/9012-45"
    )

    identifier = institution.community.identifier

    fields = InstitutionTestHelper.generate_form_fields(
      "institution new name",
      "BR",
      "DF",
      "Gama",
      "12.345.678/9012-45",
      "PrivateInstitution"
    )

    post(
      :edit_institution,
      :profile=>institution.community.identifier,
      :community=>fields[:community],
      :institutions=>fields[:institutions]
    )

    institution = Community[identifier].institution
    assert_not_equal "Ministerio Publico da Uniao", institution.community.name
  end

  should "not user edit its community institution with wrong values" do
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juridical_nature = JuridicalNature.create(:name => "Autarquia")

    institution = InstitutionTestHelper.create_public_institution(
      "Ministerio Publico da Uniao",
      "MPU",
      "BR",
      "DF",
      "Gama",
      juridical_nature,
      govPower,
      govSphere,
      "12.345.678/9012-45"
    )

    identifier = institution.community.identifier

    fields = InstitutionTestHelper.generate_form_fields(
      "",
      "BR",
      "DF",
      "Gama",
      "6465465465",
      "PrivateInstitution"
    )

    post(
      :edit_institution,
      :profile=>institution.community.identifier,
      :community=>fields[:community],
      :institutions=>fields[:institutions]
    )

    institution = Community[identifier].institution
    assert_equal "Ministerio Publico da Uniao", institution.community.name
    assert_equal "12.345.678/9012-45", institution.cnpj
  end

end
