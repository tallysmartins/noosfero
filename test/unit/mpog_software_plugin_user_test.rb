require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class MpogSoftwarePluginUserTest < ActiveSupport::TestCase
  include PluginTestHelper

  should 'not save user whose both email and secondary email are the same' do

    user = fast_create(User)
    user.email = "test@email.com"
    user.secondary_email = "test@email.com"

    assert !user.save
  end

  should 'not save user whose both email and secondary email have already been used' do
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

  should 'not save user whose email has already been used in another users secondary email' do
    user1 = create_default_user
    user2 = fast_create(User)

    user2.login = "another-login"
    user2.email = "secondary@email.com"
    user2.secondary_email = "noosfero@email.com"
    assert !user2.save
  end

  should 'not save user whose secondary email has already been used in another users email' do
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
  should 'return an error if secondary email is governmental and primary is not' do
    user = fast_create(User)

    user.email = "test@email.com"
    user.secondary_email = "test@gov.br"

    assert !user.save
    assert user.errors.full_messages.include?("The governamental email must be the primary one.")
  end

  should 'have institution if email is governmental' do
    user = fast_create(User)

    user.email = "testtest@gov.br"

    user.institutions = []
    assert !user.save, "this should not save"

    gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juridical_nature = JuridicalNature.create(:name => "Autarquia")
    institution = create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", juridical_nature, gov_power, gov_sphere, "44.555.666/7777-88")
    institution.save!

    user.institutions << institution
    assert user.save, "this should save"
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
