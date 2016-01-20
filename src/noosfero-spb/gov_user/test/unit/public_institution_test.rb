require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class PublicInstitutionTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
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
                    "11.222.333/4444-55"
                  )
  end

  def teardown
    GovernmentalPower.destroy_all
    GovernmentalSphere.destroy_all
    JuridicalNature.destroy_all
    Institution.destroy_all
    @gov_power = nil
    @gov_sphere = nil
    @juridical_nature = nil
    @institution = nil
  end

  should "save without a cnpj" do
    @institution.cnpj = nil
    assert @institution.save
  end

  should "save institution without an acronym" do
    @institution.acronym = nil
    assert @institution.save
  end

  should "Not save institution without a governmental_power" do
    invalid_msg = "Governmental power can't be blank"
    @institution.governmental_power = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? invalid_msg
  end

  should "Not save institution without a governmental_sphere" do
    invalid_msg = "Governmental sphere can't be blank"
    @institution.governmental_sphere = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? invalid_msg
  end

  should "not save institution without juridical nature" do
    invalid_msg = "Juridical nature can't be blank"
    @institution.juridical_nature = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? invalid_msg
  end


  should "verify cnpj format if it is filled" do
    @institution.cnpj = "123456789"

    assert_equal false, @institution.save

    @institution.cnpj = "11.222.333/4444-55"

    assert_equal true, @institution.save
  end
end
