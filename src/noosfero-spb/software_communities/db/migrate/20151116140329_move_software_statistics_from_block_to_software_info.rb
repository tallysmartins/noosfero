class MoveSoftwareStatisticsFromBlockToSoftwareInfo < ActiveRecord::Migration
  def up
    benefited_people = 0
    saved_resources = 0

    select_all("SELECT * FROM tasks WHERE status=3 AND type='CreateOrganizationRatingComment'").each do |task|
      settings = YAML.load(task['data'])
      organization_rating = select_one("SELECT * FROM organization_ratings WHERE id=#{settings[:organization_rating_id]}")

      benefited_people += organization_rating["people_benefited"].to_i
      saved_resources += organization_rating["saved_value"].to_f
      execute("UPDATE software_infos SET benefited_people=#{benefited_people}, saved_resources=#{saved_resources} WHERE software_infos.community_id=#{organization_rating["organization_id"]}")
    end
  end

  def down
    execute("UPDATE software_infos SET benefited_people=0, saved_resources=0")
  end
end
