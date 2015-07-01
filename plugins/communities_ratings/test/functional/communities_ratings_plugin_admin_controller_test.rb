require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../../controllers/communities_ratings_plugin_admin_controller'

# Re-raise errors caught by the controller.
class CommunitiesRatingsPluginAdminController; def rescue_action(e) raise e end; end

class CommunitiesRatingsPluginAdminControllerTest < ActionController::TestCase

  def setup
    @controller = CommunitiesRatingsPluginAdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @environment = Environment.default
    @environment.enabled_plugins = ['CommunitiesRatingsPlugin']
    @environment.save

    @community = Community.create(:name => "TestCommunity")

    login_as(create_admin_user(@environment))
  end

  test "should update communities rating plugin configuration" do
    post :update,  :environment => { :communities_ratings_default_rating => 5,
                                                            :communities_ratings_cooldown => 12,
                                                            :communities_ratings_order => "Most Recent",
                                                            :communities_ratings_per_page => 10,
                                                            :communities_ratings_vote_once => true }

    assert :success
    @environment.reload
    assert_equal 5, @environment.communities_ratings_default_rating
    assert_equal "Configuration updated successfully.", session[:notice]
  end

  test "should not update communities rating plugin configuration with wrong cooldown time" do
    post :update,  :environment => { :communities_ratings_default_rating => 5,
                                                            :communities_ratings_cooldown => -50,
                                                            :communities_ratings_order => "Most Recent",
                                                            :communities_ratings_per_page => 10,
                                                            :communities_ratings_vote_once => true }

    assert :success
    @environment.reload
    assert_equal 24, @environment.communities_ratings_cooldown
    assert_equal "Configuration could not be saved.", session[:notice]
  end
end

