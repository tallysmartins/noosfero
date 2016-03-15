class CreateOperatingNameTable < ActiveRecord::Migration
  def up
    create_table :operating_system_names do |t|
      t.string :name
    end

    file_name = "plugins/software_communities/public/static/operating_systems.txt"
    list_file = File.open file_name, "r"
    list_file.each_line do |line|
      execute("INSERT INTO operating_system_names (name) VALUES ('#{line.strip}')")
    end
    list_file.close
  end

  def down
    drop_table :operating_system_names
  end
end
