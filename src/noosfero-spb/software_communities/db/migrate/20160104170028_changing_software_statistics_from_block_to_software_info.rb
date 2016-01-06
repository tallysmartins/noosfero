class ChangingSoftwareStatisticsFromBlockToSoftwareInfo < ActiveRecord::Migration
  def up
    select_all("SELECT * FROM software_infos").each do |software|
      benefited_people = 0
      saved_resources = 0

      if software['community_id']
        select_all("SELECT * FROM tasks WHERE status=3 AND type='CreateOrganizationRatingComment' AND target_id=#{software['community_id']}").each do |task|
          settings = YAML.load(task['data'])
          organization_rating = select_one("SELECT * FROM organization_ratings WHERE id=#{settings[:organization_rating_id]}")

          benefited_people += organization_rating["people_benefited"].to_i
          saved_resources += organization_rating["saved_value"].to_f
        end
        execute("UPDATE software_infos SET benefited_people=#{benefited_people}, saved_resources=#{saved_resources} WHERE id=#{software['id']}")
      end
    end

  end

  def down
    execute("UPDATE software_infos SET benefited_people=0,saved_resources=0")
  end
end
