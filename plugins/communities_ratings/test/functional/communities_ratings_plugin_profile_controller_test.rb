require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../../controllers/communities_ratings_plugin_profile_controller'

# Re-raise errors caught by the controller.
class CommunitiesRatingsPluginProfileController; def rescue_action(e) raise e end; end

class CommunitiesRatingsPluginProfileControllerTest < ActionController::TestCase

  def setup
    @controller = CommunitiesRatingsPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @environment = Environment.default
    @environment.enabled_plugins = ['CommunitiesRatingsPlugin']
    @environment.save

    @person = create_user('testuser').person
    @community = Community.create(:name => "TestCommunity")

    login_as(@person.identifier)
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(@person.user)
  end

  test "should add new comment to community" do
    post :new_rating, profile: @community.identifier, :comments => {:body => "This is a test"}, :community_rating_value => 4
    assert_equal "#{@community.name} successfully rated!", session[:notice]
  end

  test "Create community_rating without comment body" do
    post :new_rating, profile: @community.identifier, :comments => {:body => ""}, :community_rating_value => 2

    assert_equal "#{@community.name} successfully rated!", session[:notice]
  end

  test "Do not create community_rating without a rate value" do
    post :new_rating, profile: @community.identifier, :comments => {:body => ""}, :community_rating_value => nil

    assert_equal "Sorry, there were problems rating this profile.", session[:notice]
  end

  test "do not create two ratings when vote once config is true" do
    post :new_rating, profile: @community.identifier, :comments => {:body => "This is a test"}, :community_rating_value => 3

    assert_equal "#{@community.name} successfully rated!", session[:notice]

    @environment.community_ratings_config.vote_once = true
    @environment.save

    post :new_rating, profile: @community.identifier, :comments => {:body => "This is a test 2"}, :community_rating_value => 3
    assert_equal "You can not vote on this community", session[:notice]
  end

  test "Display unavailable rating message for users that must wait the rating cooldown time" do
    post :new_rating, profile: @community.identifier, :comments => {:body => ""}, :community_rating_value => 3
    assert_not_match(/The administrators set the minimum time of/, @response.body)
    valid_rating = CommunityRating.last

    post :new_rating, profile: @community.identifier, :comments => {:body => ""}, :community_rating_value => 3
    assert_match(/The administrators set the minimum time of/, @response.body)
    new_rating = CommunityRating.last

    assert_equal valid_rating.id, new_rating.id
  end
end
