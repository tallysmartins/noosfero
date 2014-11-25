require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class DownloadBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  should 'inherit from Block' do
    assert_kind_of Block, DownloadBlock.new
  end

  should 'declare its default title' do
    DownloadBlock.any_instance.stubs(:profile_count).returns(0)
    assert_equal Block.new.default_title, DownloadBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, DownloadBlock.description
  end

  should 'have software info to download it' do

    link = "gitlab.com/teste"
    name = "Test Software"

    block = DownloadBlock.create(:name => name, :link => link)

    assert_equal block.link, link, "Link should not be empty"
    assert_equal block.name, name, "Name should not be empty"
  end
end
