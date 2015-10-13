require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class CommunitiesBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @person = create_person("My Name", "user@email.com", "123456", "123456", "Any State", "Some City")

    @software_info = create_software_info("Novo Software")
    @software_info.community.add_member(@person)

    @community = create_community("Nova Comunidade")
    @community.add_member(@person)


    @comminities_block = CommunitiesBlock.new
    @comminities_block.expects(:owner).at_least_once.returns(@person)
  end

  def teardown
    CommunitiesBlock.destroy_all
    @person = nil
    @community = nil
    @software_info = nil
  end
  should "not have community of software or institution in block" do
    assert_includes @comminities_block.profile_list, @community
    assert_not_includes @comminities_block.profile_list, @software_info.community
  end

end
