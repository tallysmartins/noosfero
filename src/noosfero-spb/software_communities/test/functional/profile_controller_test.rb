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

  should 'display admins correctly when is on the second members page' do
    community = fast_create('Community')

    for n in 1..30
      community.add_member(create_user("testuser#{"%02i" % n}").person)
    end

    for n in 31..35
      community.add_admin(create_user("testuser#{"%02i" % n}").person)
    end

    get :members, :profile => community.identifier, :members_page => 2

    for n in 1..20
      assert_no_tag :tag => 'div', :attributes => { :class => 'profile-members' }, :descendant => { :tag => 'span', :attributes => { :class => 'fn' }, :content => "testuser#{"%02i" % n}" }
    end

    for n in 31..35
      assert_tag :tag => 'div', :attributes => { :class => 'profile-admins' }, :descendant => { :tag => 'span', :attributes => { :class => 'fn' }, :content => "testuser#{"%02i" % n}" }
    end
  end


  should 'display members correctly when is on the second admins page' do
    community = fast_create('Community')

    for n in 1..10
      community.add_member(create_user("testuser#{"%02i" % n}").person)
    end

    for n in 11..15
      community.add_admin(create_user("testuser#{"%02i" % n}").person)
    end

    get :members, :profile => community.identifier, :admins_page => 2

    for n in 1..10
      assert_tag :tag => 'div', :attributes => { :class => 'profile-members' }, :descendant => { :tag => 'span', :attributes => { :class => 'fn' }, :content => "testuser#{"%02i" % n}" }
    end

    for n in 11..15
      assert_no_tag :tag => 'div', :attributes => { :class => 'profile-admins' }, :descendant => { :tag => 'span', :attributes => { :class => 'fn' }, :content => "testuser#{"%02i" % n}" }
    end
  end
end

