require File.dirname(__FILE__) + '/../../../../test/test_helper'

class MpogSoftwarePluginUserTest < ActiveSupport::TestCase

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

  should 'return an error if secondary email is governmental and primary is not' do
    user = fast_create(User)

    user.email = "test@email.com"
    user.secondary_email = "test@gov.br"

    assert !user.save
    assert user.errors.full_messages.include?("The governamental email must be the primary one.")
  end

  should 'have institution if email is governmental' do
    user = fast_create(User)

    user.email = "test@gov.br"

    user.institutions = []
    assert !user.save

    institution = build_institution "Test simple institution"
    institution.save

    user.institutions << institution
    assert user.save
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

  def build_institution name, type="PublicInstitution", cnpj=nil
    institution = Institution::new
    institution.name = name
    institution.type = type
    institution.cnpj = cnpj

    institution.community = Community.create(:name => "Simple Public Institution")
    institution.community.country = "BR"
    institution.community.state = "DF"
    institution.community.city = "Gama"

    if type == "PublicInstitution"
      institution.juridical_nature = JuridicalNature.first
    end

    institution
  end
end
