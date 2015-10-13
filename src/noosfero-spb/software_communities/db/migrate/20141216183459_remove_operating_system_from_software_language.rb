class RemoveOperatingSystemFromSoftwareLanguage < ActiveRecord::Migration
  def up
    remove_column :software_languages, :operating_system
  end

  def down
    add_column :software_languages, :operating_system, :string
  end
end
