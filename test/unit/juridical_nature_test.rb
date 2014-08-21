require File.dirname(__FILE__) + '/../../../../test/test_helper'

class JuridicalNatureTest < ActiveSupport::TestCase
  def teardown
    Institution.destroy_all
  end

  should "get public institutions" do
    juri_nature = JuridicalNature::new :name=>"Some juri nature"

    assert build_institution("one").save
    assert build_institution("two").save
    assert build_institution("three").save

    assert juri_nature.public_institutions.count == PublicInstitution.count
  end

  should "not get private institutions" do
    juri_nature = JuridicalNature::new :name=>"Some juri nature"

    assert build_institution("one", "PrivateInstitution", "00.000.000/0000-00").save
    assert build_institution("two","PrivateInstitution", "00.000.000/0000-01").save
    assert build_institution("three","PrivateInstitution", "00.000.000/0000-02").save

    assert juri_nature.public_institutions.count == 0
    assert juri_nature.public_institutions.count == PublicInstitution.count
    assert juri_nature.public_institutions.count != PrivateInstitution.count
  end

  private

  def build_institution name, type="PublicInstitution", cnpj=nil
    institution = Institution::new
    institution.name = name
    institution.type = type
    institution.cnpj = cnpj

    if type == "PublicInstitution"
      institution.juridical_nature = JuridicalNature.first
    end

    institution
  end
end
