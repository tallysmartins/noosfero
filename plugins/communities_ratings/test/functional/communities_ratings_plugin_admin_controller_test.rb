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
    post :update,  :community_ratings_config => { :default_rating => 5,
                                                            :cooldown => 12,
                                                            :order => "recent",
                                                            :per_page => 10,
                                                            :vote_once => true }

    assert :success
    @environment.reload
    assert_equal 5, @environment.community_ratings_config.default_rating
    assert_equal "Configuration updated successfully.", session[:notice]
  end

  test "should not update communities rating plugin configuration with negative cooldown time" do
    post :update,  :community_ratings_config => { :default_rating => 5,
                                                  :cooldown => -50,
                                                  :order => "recent",
                                                  :per_page => 10,
                                                  :vote_once => true }

    assert :success
    @environment.reload
    assert_equal 24, @environment.community_ratings_config.cooldown
    assert_equal "Configuration could not be saved.", session[:notice]
  end
end

