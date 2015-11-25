class CreateOperatingNameTable < ActiveRecord::Migration
  def up
    create_table :operating_system_names do |t|
      t.string :name
    end
  end

  def down
    drop_table :operating_system_names
  end
end
