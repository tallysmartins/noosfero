#encoding: utf-8
require "i18n"

class CreateSiorgInstitutions < ActiveRecord::Migration
  def up
    governmental_power = GovernmentalPower.where("name ILIKE ?", "Executivo").first
    governmental_sphere = GovernmentalSphere.where("name ILIKE ?", "Federal").first
    env = Environment.default

    if env && governmental_power && governmental_sphere
      CSV.foreach("plugins/spb_migrations/files/orgaos_siorg.csv", :headers => true) do |row|
        template = Community["institution"]

        community = Community.where("identifier ILIKE ?", row["Nome"].to_slug).first
        unless community
          institution = Institution.where("acronym ILIKE ?", row["Sigla"]).first
          community = institution.community if institution
        end

        community = Community.new unless community

        community.environment = env if community.environment.blank?
        community.name = row["Nome"].rstrip
        community.country = row["Pais"]
        community.state = row["Estado"]
        community.city = row["Cidade"]
        community.template = template if template

        unless community.save
          print "F"
          next
        end

        juridical_nature = JuridicalNature.where("name ILIKE ? OR name ILIKE ?", "#{I18n.transliterate(row['Natureza Jurídica'].rstrip)}", "#{row['Natureza Jurídica'].rstrip}").first

        juridical_nature = JuridicalNature.create!(name: row['Natureza Jurídica'].rstrip) unless juridical_nature


        institution = Hash.new

        institution[:name] = row["Nome"]
        institution[:siorg_code] = row["Código do SIORG"]
        institution[:acronym] = row["Sigla"]
        institution[:governmental_sphere] = governmental_sphere
        institution[:governmental_power] = governmental_power
        institution[:juridical_nature] = juridical_nature
        institution[:sisp] = (row["SISP"] == "Sim")
        institution[:cnpj] = row["CNPJ"]
        institution[:community] = community

        if community.institution
          community.institution.update_attributes(institution)
        else
          institution[:community] = community
          community.institution = PublicInstitution.create!(institution)
        end

        if community.save
          print "."
        else
          print "F"
        end

      end
    end
    puts ""
  end

  def down
    say "This can't be reverted"
  end

end
