class AddFirstEditToSoftware < ActiveRecord::Migration
  def up
    add_column :software_infos, :first_edit, :boolean, :default => true
  end

  def down
    remove_column :software_infos, :first_edit
  end
end
