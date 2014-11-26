require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class RepositoryBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  should 'inherit from Block' do
    assert_kind_of Block, RepositoryBlock.new
  end

  should 'declare its default title' do
    RepositoryBlock.any_instance.stubs(:profile_count).returns(0)
    assert_equal Block.new.default_title, RepositoryBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, RepositoryBlock.description
  end

  should 'have software info to repository it' do

    link = "gitlab.com/teste"

    block = RepositoryBlock.create(:link => link)

    assert_equal block.link, link, "Link should not be empty"
  end
end
