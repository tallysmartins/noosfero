class AddFinalityFieldToSoftwareTable < ActiveRecord::Migration
  def up
    add_column :software_infos, :finality, :string, :limit => 140
  end

  def down
    remove_column :software_info, :finality
  end
end
