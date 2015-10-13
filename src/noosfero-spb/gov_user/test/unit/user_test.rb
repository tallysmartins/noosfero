require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class UserTest < ActiveSupport::TestCase
  include PluginTestHelper

  should 'not save user whose both email and secondary email are the same' do
    user = fast_create(User)
    user.email = "test@email.com"
    user.secondary_email = "test@email.com"

    assert !user.save
  end

  should 'not save user whose email and secondary email have been taken' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.email = "primary@email.com"
    user2.secondary_email = "secondary@email.com"
    assert !user2.save
  end

  should 'not save user whose email has already been used' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.email = "primary@email.com"
    user2.secondary_email = "noosfero@email.com"
    assert !user2.save
  end

  should 'not save user whose email has been taken another in users secondary email' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.login = "another-login"
    user2.email = "secondary@email.com"
    user2.secondary_email = "noosfero@email.com"
    assert !user2.save
  end

  should 'not save user whose secondary email has been taken used in another users email' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.login = "another-login"
    user2.email = "noosfero@email.com"
    user2.secondary_email = "primary@email.com"
    assert !user2.save
  end

  should 'not save user whose secondary email has already been used in another users secondary email' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.login = "another-login"
    user2.email = "noosfero@email.com"
    user2.secondary_email = "secondary@email.com"
    assert !user2.save
  end

  should 'not save user whose secondary email is in the wrong format' do
    user = fast_create(User)
    user.email = "test@email.com"
    user.secondary_email = "notarightformat.com"

    assert !user.save

    user.secondary_email = "not@arightformatcom"

    assert !user.save
  end

  should 'save more than one user without secondary email' do
    user = fast_create(User)
    user.email = "test@email.com"
    user.secondary_email = ""
    user.save

    user2 = fast_create(User)
    user2.email = "test2@email.com"
    user2.secondary_email = ""
    assert user2.save
  end

  private

  def create_default_user
    user = fast_create(User)
    user.login = "a-login"
    user.email = "primary@email.com"
    user.secondary_email = "secondary@email.com"
    user.save

    return user
  end

end
