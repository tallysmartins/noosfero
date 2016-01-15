class AddTimestampsToSoftwareInfo < ActiveRecord::Migration
  def up
    change_table :software_infos do |t|
      t.datetime :created_at, :null => false, :default => Time.zone.now
      t.datetime :updated_at, :null => false, :default => Time.zone.now
    end
  end

  def down
    remove_column :software_infos, :created_at
    remove_column :software_infos, :updated_at
  end
end
