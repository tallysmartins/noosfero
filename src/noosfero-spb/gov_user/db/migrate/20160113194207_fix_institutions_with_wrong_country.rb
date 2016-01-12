class FixInstitutionsWithWrongCountry < ActiveRecord::Migration
  def up
    select_all("SELECT id, data FROM profiles WHERE type = 'Community'").each do |community|
      settings = YAML.load(community['data'] || {}.to_yaml)
      if !settings[:country].nil? && settings[:country].downcase == "brasil"
        settings[:country] = 'BR'
        assignments = ActiveRecord::Base.send(:sanitize_sql_for_assignment, {:data => settings.to_yaml})
        update("UPDATE profiles SET %s WHERE id = %d" % [assignments, community['id']])
      end
    end
  end

  def down
    say "This migration can't be reverted."
  end
end
