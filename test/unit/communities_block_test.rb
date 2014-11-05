require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class CommunitiesBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @person = create_person("My Name", "user@email.com", "123456", "123456", "user@secondary_email.com", "Any State", "Some City")

    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

    @institution = InstitutionTestHelper.create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @gov_power, @gov_sphere, "12.345.678/9012-45")
    @institution.community.add_member(@person)

    @software_info = create_software_info("Novo Software")
    @software_info.community.add_member(@person)

    @community = create_community("Nova Comunidade")
    @community.add_member(@person)


    @comminities_block = CommunitiesBlock.new
    @comminities_block.expects(:owner).at_least_once.returns(@person)
  end

  should "not have community of software or institution in block" do
    assert_equal 1, @comminities_block.profile_list.count
  end

end
