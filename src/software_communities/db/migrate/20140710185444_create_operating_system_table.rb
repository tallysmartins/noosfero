class CreateOperatingSystemTable < ActiveRecord::Migration
  def up
    create_table :operating_systems do |t|
      t.string :name
      t.string :version
      t.references :software_info
    end
  end

  def down
    drop_table :operating_systems
  end
end
