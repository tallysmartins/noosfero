class CreateOperatingNameTable < ActiveRecord::Migration
  def up
    create_table :operating_system_names do |t|
      t.string :name
    end

    path_to_file = "plugins/software_communities/public/static/operating_systems.txt"
    SoftwareHelper.create_list_with_file(path_to_file, OperatingSystemName)
  end

  def down
    drop_table :operating_system_names
  end
end
