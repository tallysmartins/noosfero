module PluginTestHelper
  def create_person name, email, password, password_confirmation, secondary_email, state, city
    user = create_user(
            name.to_slug,
            email,
            password,
            password_confirmation,
            secondary_email
            )
    person = Person::new

    user.person = person
    person.user = user

    person.name = name
    person.identifier = name.to_slug
    person.state = state
    person.city = city

    user.save
    person.save

    person
  end

  def create_user login, email, password, password_confirmation, secondary_email
    user = User.new

    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation
    user.secondary_email = secondary_email

    user
  end
end
