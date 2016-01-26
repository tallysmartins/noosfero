require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class InstitutionTest < ActiveSupport::TestCase
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
    @institution = nil
  end

  should "not save institutions without name" do
    @institution.name = nil
    assert_equal false, @institution.save
    assert_equal true, @institution.errors.messages.keys.include?(:name)
  end

  should "not save if institution has invalid type" do
    invalid_msg = "Type invalid, only public and private institutions are allowed."
    @institution.type = "Other type"
    assert_equal false, @institution.save
    assert_equal true, @institution.errors.messages.keys.include?(:type)
  end

  should "not save without country" do
    @institution.community.country = nil
    assert_equal false, @institution.save
    assert_equal true, @institution.errors.messages.keys.include?(:country)
  end

  should "not save without state" do
    @institution.community.state = nil

    assert_equal false, @institution.save
    assert_equal true, @institution.errors.messages.keys.include?(:state)
  end

  should "not save without city" do
    @institution.community.city = nil
    @institution.community.state = "DF"

    assert_equal false, @institution.save
    assert_equal true, @institution.errors.messages.keys.include?(:city)
  end

  should "only return institutions of a specific environment" do
    env1 = Environment.create(:name => "Environment One")
    env2 = Environment.create(:name => "Environment Two")

    env1.communities << @institution.community
    search_result_env1 = Institution.search_institution("Ministerio", env1).collect{ |i| i.id }
    search_result_env2 = Institution.search_institution("Ministerio", env2).collect{ |i| i.id }

    assert_includes search_result_env1, @institution.id
    assert_not_includes search_result_env2, @institution.id
  end
end
