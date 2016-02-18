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

  should "display limited community events" do
    @e1 = Event.new :name=>"Event 1", :body=>"Event 1 body",
                   :start_date=>DateTime.now,
                   :end_date=>(DateTime.now + 1.month)

    @e2 = Event.new :name=>"Event 2", :body=>"Event 2 body",
                  :start_date=>(DateTime.now + 10.days),
                  :end_date=>(DateTime.now + 11.days)

    @e3 = Event.new :name=>"Event 3", :body=>"Event 3 body",
                  :start_date=>(DateTime.now + 20.days),
                  :end_date=>(DateTime.now + 30.days)

    @software.community.events << @e1
    @software.community.events << @e2
    @software.community.events << @e3
    @software.community.save!

    events_block = SoftwareEventsBlock.new
    events_block.amount_of_events = 2
    events_block.display = "always"
    box = MainBlock.last.box
    events_block.box = box
    events_block.save!

    get :index, :profile=>@software.community.identifier
    assert_tag :tag => 'div', :attributes => { :class => 'software-community-events-block' }, :descendant => { :tag => 'a', :content => 'Event 1' }
    assert_tag :tag => 'div', :attributes => { :class => 'software-community-events-block' }, :descendant => { :tag => 'a', :content => 'Event 2' }
    assert_no_tag :tag => 'div', :attributes => { :class => 'software-community-events-block' }, :descendant => { :tag => 'a', :content => 'Event 3' }
  end

  should "notice when given invalid download params" do
    download_block = DownloadBlock.last
    get :download_file, :profile=>@software.community.identifier,
        :block => download_block.id, :download_index => -5

    assert_equal "Invalid download params", session[:notice]
  end
end
