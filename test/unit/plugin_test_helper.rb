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
    institution.save!

    institution
  end

  def create_private_institution name, cnpj, country, state, city
    institution = PrivateInstitution.new
    institution.community = create_community_institution(name, country, state, city)
    institution.name = name
    institution.sisp = false
    institution.cnpj = cnpj
    institution.save!

    institution
  end

  def create_community_institution name, country, state, city
    community = fast_create(Community)
    community.name = name
    community.country = country
    community.state = state
    community.city = city
    community.save!
    community
  end

end
