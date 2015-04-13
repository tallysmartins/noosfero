Given /^Institutions has initial default values on database$/ do
  GovernmentalPower.create(:name => "Executivo")
  GovernmentalPower.create(:name => "Legislativo")
  GovernmentalPower.create(:name => "Judiciario")

  GovernmentalSphere.create(:name => "Federal")

  JuridicalNature.create(:name => "Autarquia")
  JuridicalNature.create(:name => "Administracao Direta")
  JuridicalNature.create(:name => "Empresa Publica")
  JuridicalNature.create(:name => "Fundacao")
  JuridicalNature.create(:name => "Orgao Autonomo")
  JuridicalNature.create(:name => "Sociedade")
  JuridicalNature.create(:name => "Sociedade Civil")
  JuridicalNature.create(:name => "Sociedade de Economia Mista")

  national_region = NationalRegion.new
  national_region.name = "Distrito Federal"
  national_region.national_region_code = '35'
  national_region.national_region_type_id = NationalRegionType::STATE
  national_region.save
end


Given /^the following public institutions?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |item|
    community = Community.new
    community.name = item[:name]
    community.country = item[:country]
    community.state = item[:state]
    community.city = item[:city]
    community.save!

    governmental_power = GovernmentalPower.where(:name => item[:governmental_power]).first
    governmental_sphere = GovernmentalSphere.where(:name => item[:governmental_sphere]).first

    juridical_nature = JuridicalNature.create(:name => item[:juridical_nature])

    institution = PublicInstitution.new(:name => item[:name], :type => "PublicInstitution", :acronym => item[:acronym], :cnpj => item[:cnpj], :juridical_nature => juridical_nature, :governmental_power => governmental_power, :governmental_sphere => governmental_sphere)
    institution.community = community
    institution.corporate_name = item[:corporate_name]
    institution.save!
  end
end
