require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class JuridicalNatureTest < ActiveSupport::TestCase

  include PluginTestHelper

  def setup
    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
  end

  def teardown
    Institution.destroy_all
  end

  should "get public institutions" do
    juridical_nature = JuridicalNature.create(:name => "Autarquia")
    create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", juridical_nature, @govPower, @govSphere)
    create_public_institution("Tribunal Regional da Uniao", "TRU", "BR", "DF", "Brasilia", juridical_nature, @govPower, @govSphere)
    assert juridical_nature.public_institutions.count == PublicInstitution.count
  end
end
