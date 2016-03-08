require 'test_helper'
require 'organization_ratings_plugin_profile_controller'
require File.dirname(__FILE__) + '/../helpers/software_test_helper'

# Re-raise errors caught by the controller.
class OrganizationRatingsPluginProfileController; def rescue_action(e) raise e end; end

class OrganizationRatingsPluginProfileControllerTest < ActionController::TestCase
  include SoftwareTestHelper

  def setup
    @controller = OrganizationRatingsPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @environment = Environment.default
    @environment.enabled_plugins = ['OrganizationRatingsPlugin']
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.save

    SoftwareCommunitiesPlugin::LicenseInfo.create(:version=>"CC-GPL-V2",
                      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt")

    @person = create_user('testuser').person
    @software = create_software(software_fields)
    @statistic_block = SoftwareCommunitiesPlugin::StatisticBlock.new
    @software.community.blocks << @statistic_block
    @software.community.save!

    login_as(@person.identifier)
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(@person.user)
  end

  test "should create a task with a valid benefited people value and no comment" do
    assert_difference 'CreateOrganizationRatingComment.count' do
      post :new_rating, profile: @software.community.identifier, :comments => {:body => ""},
                        :organization_rating_value => 3, :organization_rating => {:people_benefited => 50}
    end
  end

  test "should create a task with a valid saved value and no comment" do
    assert_difference 'CreateOrganizationRatingComment.count' do
      post :new_rating, profile: @software.community.identifier, :comments => {:body => "po"},
                        :organization_rating_value => 3, :organization_rating => {:saved_value => 50000000}
    end
  end

  test "should not create a task with no saved value or benefited poeple, and no comment" do
    assert_no_difference 'CreateOrganizationRatingComment.count' do
      post :new_rating, profile: @software.community.identifier, :comments => {:body => ""},
                        :organization_rating_value => 3, :organization_rating => nil
    end
  end

  test "software statistics should be updated when task is accepted" do
    @software.reload
    assert_equal 0, @software.benefited_people
    assert_equal 0.0, @software.saved_resources

    post :new_rating, profile: @software.community.identifier, :comments => {:body => "po"},
                      :organization_rating_value => 3, :organization_rating => {:saved_value => 500, :people_benefited => 10}

    CreateOrganizationRatingComment.last.finish
    @software.reload
    assert_equal 10, @software.benefited_people
    assert_equal 500.0, @software.saved_resources
  end

  test "software statistics should not be updated when task is cancelled" do
    @software.reload
    assert_equal 0, @software.benefited_people
    assert_equal 0.0, @software.saved_resources

    post :new_rating, profile: @software.community.identifier, :comments => {:body => "Body"},
                      :organization_rating_value => 3,
                      :organization_rating => {:saved_value => 500, :people_benefited => 10}

    CreateOrganizationRatingComment.last.cancel
    @software.reload
    assert_equal 0, @software.benefited_people
    assert_equal 0.0, @software.saved_resources
  end
end
