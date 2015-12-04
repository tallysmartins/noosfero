require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwaresBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  should 'inherit from ProfileListBlock' do
    assert_kind_of ProfileListBlock, SoftwaresBlock.new
  end

  should 'declare its default title' do
    SoftwaresBlock.any_instance.stubs(:profile_count).returns(0)
    assert_not_equal ProfileListBlock.new.default_title, SoftwaresBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal ProfileListBlock.description, SoftwaresBlock.description
  end

  should 'give empty footer on unsupported owner type' do
    block = SoftwaresBlock.new
    block.expects(:owner).returns(1)
    assert_equal '', block.footer
  end

  should 'list softwares' do
    user = create_person("Jose_Augusto",
            "jose_augusto@email.com",
            "aaaaaaa",
            "aaaaaaa",
            "DF",
            "Gama"
          )

    software_info = create_software_info("new software")
    software_info.community.add_member(user)

    block = SoftwaresBlock.new
    block.expects(:owner).at_least_once.returns(user)

    assert_equivalent [software_info.community], block.profiles
  end

end
