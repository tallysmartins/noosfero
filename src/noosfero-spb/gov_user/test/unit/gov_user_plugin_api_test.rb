require File.dirname(__FILE__) + '/../../../../test/unit/api/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class GovUserPlugin::ApiTest < ActiveSupport::TestCase

  include PluginTestHelper

  def setup
    login_api
    environment = Environment.default
    environment.enable_plugin(GovUserPlugin)
    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")
    @institution = create_public_institution(
                      "Ministerio Publico da Uniao",
                      "MPU",
                      "BR",
                      "Distrito Federal",
                      "Gama",
                      @juridical_nature,
                      @gov_power,
                      @gov_sphere,
                      "11.222.333/4444-55")
  end

  should 'list all institutions' do
    @institution1 = create_public_institution(
                      "Instituicao bacana",
                      "IB",
                      "BR",
                      "Distrito Federal",
                      "Gama",
                      @juridical_nature,
                      @gov_power,
                      @gov_sphere,
                      "11.222.333/4444-56"
                    )

    get "/api/v1/gov_user/institutions?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [@institution.id, @institution1.id], json['institutions'].map {|c| c['id']}
  end

  should 'get institution by id' do
    get "/api/v1/gov_user/institutions/#{@institution.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal @institution.id, json["institution"]["id"]
  end

end
