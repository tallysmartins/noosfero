class RemoveOperatingSystemFromSoftwareDatabase < ActiveRecord::Migration
  def up
    remove_column :software_databases, :operating_system
  end

  def down
    add_column :software_databases, :operating_system, :string
  end
end
