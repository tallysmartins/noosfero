class ChangeOperatingSystemsTable < ActiveRecord::Migration
  def up
    change_table :operating_systems do |t|
      t.remove :name
      t.references :operating_system_name
    end

  end

  def down
    change_table :operating_systems do |t|
      t.string :name
      t.remove :operating_system_name_id
    end
  end
end
