require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class PublicInstitutionTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

    @institution = create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @gov_power, @gov_sphere)
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
    @institution.governmental_power = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Governmental power can't be blank"
  end

  should "Not save institution without a governmental_sphere" do
    @institution.governmental_sphere = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Governmental sphere can't be blank"
  end

  should "not save institution without juridical nature" do
    @institution.juridical_nature = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Juridical nature can't be blank"
  end
end
