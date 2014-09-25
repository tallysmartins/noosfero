module PluginTestHelper

  def create_public_institution name, acronym, country, state, city, juridical_nature, gov_p, gov_s
    institution = PublicInstitution.new
    institution.community = create_community_institution(name, country, state, city)
    institution.name = name
    institution.juridical_nature = juridical_nature
    institution.sisp = false
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.save

    institution
  end

  def create_private_institution name, cnpj, country, state, city
    institution = PrivateInstitution.new
    institution.community = create_community_institution(name, country, state, city)
    institution.name = name
    institution.sisp = false
    institution.cnpj = cnpj
    institution.save

    institution
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

  def create_user login, email, password, password_confirmation, secondary_email
    user = User.new
    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation
    user.secondary_email = secondary_email
    user.save
    user.person.save
    user
  end

  def create_person name, email, password, password_confirmation, secondary_email, state, city
    user = create_user(name.downcase, email, password, password_confirmation, secondary_email)
    user.person.name = name
    user.person.state = state
    user.person.city = city
    user.person.save
    user.person
  end

end
