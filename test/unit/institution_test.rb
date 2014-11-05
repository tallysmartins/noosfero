require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class InstitutionTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

    @institution = create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @gov_power, @gov_sphere, "11.222.333/4444-55")
  end

  should "not save institutions without name" do
    @institution.name = nil
    assert !@institution.save
    assert @institution.errors.full_messages.include? "Name can't be blank"
  end

  should "not save if institution has invalid type" do
    @institution.type = "Other type"
    assert !@institution.save, 'Invalid type'
    assert @institution.errors.full_messages.include? "Type invalid, only public and private institutions are allowed."
  end
  
  should "not save without country" do 
    @institution.community.country = nil
    assert !@institution.save, "Country can't be blank"
    assert @institution.errors.full_messages.include? "Country can't be blank"
  end

  should "not save without state" do 
    @institution.community.state = nil

    assert !@institution.save, "State can't be blank"
    assert @institution.errors.full_messages.include? "State can't be blank"
  end

  should "not save without city" do
    @institution.community.city = nil

    assert !@institution.save, "City can't be blank"
    assert @institution.errors.full_messages.include? "City can't be blank"
  end
end
