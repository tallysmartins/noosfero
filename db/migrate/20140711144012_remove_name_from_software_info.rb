class RemoveNameFromSoftwareInfo < ActiveRecord::Migration
  def up
    remove_column :software_infos, :name
  end

  def down
    add_column :software_infos, :name, :string
  end
end
