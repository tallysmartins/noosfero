class AddLicenseToSoftwaresWithNone < ActiveRecord::Migration
  def up
    execute("UPDATE software_communities_plugin_software_infos SET license_info_id=(SELECT id FROM software_communities_plugin_license_infos WHERE version='Another') WHERE license_info_id IS NULL;")
  end

  def down
    say "This migration can't be reverted"
  end
end
