class CreateDatabaseDescriptionsTable < ActiveRecord::Migration
  def self.up
    create_table :database_descriptions do |t|
      t.string :name
    end

    file_name = "plugins/software_communities/public/static/databases.txt"
    list_file = File.open file_name, "r"
    list_file.each_line do |line|
      execute("INSERT INTO database_descriptions (name) VALUES ('#{line.strip}')")
    end
    list_file.close
  end

  def self.down
    drop_table :database_descriptions
  end
end
