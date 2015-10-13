class AddSettingsFieldToSoftwareInfo < ActiveRecord::Migration
  def up
    add_column :software_infos, :settings, :text
  end

  def down
    remove_column :software_info, :settings
  end
end
