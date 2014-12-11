require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'

class GovernmentalPowerTest < ActiveSupport::TestCase

  def setup
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")
  end

  def teardown
    Institution.destroy_all
  end

  should "get public institutions" do
    gov_power = GovernmentalPower::new :name=>"Some gov power"
    InstitutionTestHelper.create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, gov_power, @gov_sphere, "12.345.678/9012-45")

    assert_equal gov_power.public_institutions.count, PublicInstitution.count
  end
end