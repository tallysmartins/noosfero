require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class RepositoryBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  should 'inherit from Block' do
    assert_kind_of Block, SoftwareCommunitiesPlugin::RepositoryBlock.new
  end

  should 'declare its default title' do
    SoftwareCommunitiesPlugin::RepositoryBlock.any_instance.stubs(:profile_count).returns(0)
    assert_equal Block.new.default_title, SoftwareCommunitiesPlugin::RepositoryBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, SoftwareCommunitiesPlugin::RepositoryBlock.description
  end
end
