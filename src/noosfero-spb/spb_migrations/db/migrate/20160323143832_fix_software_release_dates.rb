# encoding: utf-8

class FixSoftwareReleaseDates < ActiveRecord::Migration
  def up
    names_mapping = {
      'Citsmart' => 'Citsmart-ITSM',
      'SGD – Sistema de Gestão de Demandas' => 'SGD - Sistema de Gestão de Demandas',
      'SNEP PBX IP' => 'SNEP',
      'WebIntegrator- Produtividade Java WEB' => 'WebIntegrator - Produtividade Java WEB'
    }
    file = File.open("plugins/spb_migrations/files/date-communities.txt", "r")
    while (line = file.gets)
      result = line.split('|')
      software_name = result[2].gsub("/n", "").strip
      unless names_mapping[software_name].nil?
         software_name = names_mapping[software_name]
      end
      software = select_one("SELECT * FROM profiles WHERE name ILIKE '#{software_name}'")
      if !software.nil?
        execute("UPDATE profiles SET created_at='#{Time.zone.parse(result[1])}' WHERE id='#{software['id']}'")
      else
        puts "Software not found: #{software_name}"
      end
    end
    file.close
  end

  def down
    say "This can't be reverted"
  end

end
