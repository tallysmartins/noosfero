require 'test_helper'
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
    software_description1 = "One Software"
    size1 = "10KB"

    link2 = "gitlab.com/teste/2"
    name2 = "Test Software2"
    software_description2 = "Another Software"
    size2 = "15KB"

    block = DownloadBlock.new
    block.update_attributes(:downloads => [{:name => name1, :link => link1, :software_description => software_description1, :size => size1},
                                             {:name => name2, :link => link2, :software_description => software_description2, :size => size2}])

    assert_equal block.download_records.all[0].link, link1, "Link should not be empty"
    assert_equal block.download_records.all[0].name, name1, "Name should not be empty"
    assert_equal block.download_records.all[1].link, link2, "Link should not be empty"
    assert_equal block.download_records.all[1].name, name2, "Name should not be empty"
  end

  should "save only valid downloads, and do not clean downloads hash" do
    downloads_sample_data = [
      { :name=>"Sample data A", :link=>"http://some.url.com", :software_description=>"all", :size=>"10 mb" },
      { :name=>"incomplete download", :link=>"", :software_description=>"Linux", :size=>"" }
    ]

    download_block = DownloadBlock.create
    download_block.downloads = downloads_sample_data

    download_block.update_downloads
    assert_equal 1, download_block.download_records.size
    assert_equal downloads_sample_data, download_block.downloads
  end
end
