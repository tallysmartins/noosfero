require File.dirname(__FILE__) + '/../helpers/institution_test_helper'

module PluginTestHelper

  def create_person name, email, password, password_confirmation, state="state", city="city"
    user = create_user(
            name.to_slug,
            email,
            password,
            password_confirmation
            )
    person = Person.new

    person.name = name
    person.identifier = name.to_slug
    person.state = state
    person.city = city

    user.person = person
    user.save

    person.user_id = user.id
    person.save

    person
  end

  def create_user login, email, password, password_confirmation
    user = User.new

    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation

    user
  end

  def create_public_institution *params
    InstitutionTestHelper.create_public_institution *params
  end

  def create_community name
    community = fast_create(Community)
    community.name = name
    community.save
    community
  end


  def create_private_institution name, acronym, country, state, city, cnpj
    InstitutionTestHelper.create_private_institution(
      name,
      acronym,
      country,
      state,
      city,
      cnpj
    )
  end

  def create_public_institution *params
    InstitutionTestHelper.create_public_institution *params
  end

  def create_community_institution name, country, state, city
    community = fast_create(Community)
    community.name = name
    community.country = country
    community.state = state
    community.city = city
    community.save
    community
  end
end
