require File.dirname(__FILE__) + '/../../../../test/test_helper'

class GovernmentalPowerTest < ActiveSupport::TestCase
  def teardown
    Institution.destroy_all
  end

  should "get public institutions" do
    gov_power = GovernmentalPower::new :name=>"Some gov power"

    assert build_institution("one").save
    assert build_institution("two").save
    assert build_institution("three").save

    assert gov_power.public_institutions.count == PublicInstitution.count
  end

  should "not get private institutions" do
    gov_power = GovernmentalPower::new :name=>"Some gov power"

    assert build_institution("one", "PrivateInstitution", "00.000.000/0000-00").save
    assert build_institution("two","PrivateInstitution", "00.000.000/0000-01").save
    assert build_institution("three","PrivateInstitution", "00.000.000/0000-02").save

    assert gov_power.public_institutions.count == 0
    assert gov_power.public_institutions.count == PublicInstitution.count
    assert gov_power.public_institutions.count != PrivateInstitution.count
  end

  private

  def build_institution name, type="PublicInstitution", cnpj=nil
    institution = Institution::new
    institution.name = name
    institution.type = type
    institution.cnpj = cnpj

    institution.community = Community.create(:name => "Simple Public Institution")
    institution.community.country = "BR"
    institution.community.state = "DF"
    institution.community.city = "Gama"

    if type == "PublicInstitution"
      institution.governmental_power = GovernmentalPower.first
      institution.governmental_sphere = GovernmentalSphere.first
    end

    institution
  end
end