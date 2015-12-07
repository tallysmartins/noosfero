class AddStatisticsToSoftwareInfo < ActiveRecord::Migration
  def up
    add_column :software_infos, :benefited_people, :integer, :default => 0
    add_column :software_infos, :saved_resources, :decimal, :default => 0
  end

  def down
    remove_column :software_infos, :benefited_people
    remove_column :software_infos, :saved_resources
  end
end
