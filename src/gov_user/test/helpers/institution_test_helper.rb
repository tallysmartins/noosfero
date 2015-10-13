module InstitutionTestHelper

  def self.generate_form_fields name, country, state, city, cnpj, type
    fields = {
      :community => {
        :name => name,
        :country => country,
        :state => state,
        :city => city
      },
      :institutions => {
        :cnpj=> cnpj,
        :type => type,
        :acronym => "",
        :governmental_power => "",
        :governmental_sphere => "",
        :juridical_nature => "",
        :corporate_name => "coporate default"
      }
    }
    fields
  end

  def self.create_public_institution name, acronym, country, state, city, juridical_nature, gov_p, gov_s, cnpj
    institution = PublicInstitution.new
    institution.community = institution_community(name, country, state, city)
    institution.name = name
    institution.juridical_nature = juridical_nature
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.cnpj = cnpj
    institution.corporate_name = "corporate default"
    institution.save
    institution
  end

  def self.create_private_institution name, acronym, country, state, city, cnpj
    institution = PrivateInstitution.new
    institution.community = institution_community(name, country, state, city)
    institution.name = name
    institution.acronym = acronym
    institution.cnpj = cnpj
    institution.corporate_name = "corporate default"
    institution.save

    institution
  end

  def self.institution_community name, country, state, city
    institution_community = Community::new
    institution_community.name = name
    institution_community.country = country
    institution_community.state = state
    institution_community.city = city
    institution_community.save
    institution_community
  end
end