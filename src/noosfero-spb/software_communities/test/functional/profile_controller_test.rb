require "test_helper"
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < ActionController::TestCase
  def setup
    Environment.default.enable('products_for_enterprises')
    @profile = create_user('testuser').person
  end
  attr_reader :profile

  should 'not count a visit twice for the same user' do
    profile = create_user('someone').person
    login_as(@profile.identifier)
    community = fast_create('Community')

    get :index, :profile => community.identifier
    community.reload
    assert_equal 1, community.hits

    get :index, :profile => community.identifier
    community.reload
    assert_equal 1, community.hits
  end

  should 'not count a visit twice for unlogged users' do
    profile = create_user('someone').person
    community = fast_create('Community')
    get :index, :profile => community.identifier
    community.reload
    assert_equal 1, community.hits

    get :index, :profile => community.identifier
    community.reload
    assert_equal 1, community.hits
  end
end

