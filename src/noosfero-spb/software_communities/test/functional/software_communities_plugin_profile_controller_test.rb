require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/software_test_helper'
require File.dirname(__FILE__) + '/../../controllers/software_communities_plugin_profile_controller'

class SoftwareCommunitiesPluginProfileController; def rescue_action(e) raise e end; end

class SoftwareCommunitiesPluginProfileControllerTest < ActionController::TestCase
  include SoftwareTestHelper

  def setup
    @controller = SoftwareCommunitiesPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @environment = Environment.default
    @environment.enable_plugin('SoftwareCommunitiesPlugin')
    @environment.save!

    LicenseInfo.create(
      :version=>"CC-GPL-V2",
      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    )
    @download_data = {
      :name=>"Google",
      :link=>"http://google.com",
      :software_description=>"all",
      :minimum_requirements=>"none",
      :size=>"?",
      :total_downloads=>0
    }

    @software = create_software(software_fields)
    @software.save!

    download_block = DownloadBlock.new
    download_block.downloads = Download.validate_download_list([@download_data])
    download_block.save!

    @software.community.blocks << download_block
    @software.community.save!
  end

  should 'redirect to download link with correct params' do
    download_block = DownloadBlock.last
    get :download_file, :profile=>@software.community.identifier,
        :block => download_block.id, :download_index => 0

    assert_equal nil, session[:notice]
    assert_redirected_to download_block.downloads[0][:link]
  end

  should "notice when the download was not found" do
    download_block = DownloadBlock.last
    get :download_file, :profile=>@software.community.identifier,
        :block => 123, :download_index => 0

    assert_equal "Could not find the download file", session[:notice]
  end

  should "notice when given invalid download params" do
    download_block = DownloadBlock.last
    get :download_file, :profile=>@software.community.identifier,
        :block => download_block.id, :download_index => -5

    assert_equal "Invalid download params", session[:notice]
  end
end
