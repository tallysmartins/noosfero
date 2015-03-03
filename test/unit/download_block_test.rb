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

    link1 = "gitlab.com/teste"
    name1 = "Test Software"

    link2 = "gitlab.com/teste/2"
    name2 = "Test Software2"

    block = DownloadBlock.create(:downloads => [{:name => name1, :link => link1}, {:name => name2, :link => link2}])

    assert_equal block.downloads[0][:link], link1, "Link should not be empty"
    assert_equal block.downloads[0][:name], name1, "Name should not be empty"
    assert_equal block.downloads[1][:link], link2, "Link should not be empty"
    assert_equal block.downloads[1][:name], name2, "Name should not be empty"
  end
end
