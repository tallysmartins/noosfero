class CreateOperatingNameTable < ActiveRecord::Migration
  def up
  	create_table :operating_system_names do |t|
      t.string :name
    end

    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/operating_systems.txt", OperatingSystemName)
  end

  def down
  	drop_table :operating_system_names
  end
end
