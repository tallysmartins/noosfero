require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class UserTest < ActiveSupport::TestCase
  include PluginTestHelper

  should 'not save user whose email has already been used' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.email = "primary@email.com"
    assert !user2.save
  end

  private

  def create_default_user
    user = fast_create(User)
    user.login = "a-login"
    user.email = "primary@email.com"
    user.save

    return user
  end
end
