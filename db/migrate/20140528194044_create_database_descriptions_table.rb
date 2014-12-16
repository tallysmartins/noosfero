class CreateDatabaseDescriptionsTable < ActiveRecord::Migration
  def self.up
    create_table :database_descriptions do |t|
      t.string :name
    end

    path_to_file = "plugins/mpog_software/public/static/databases.txt"
    SoftwareHelper.create_list_with_file(path_to_file, DatabaseDescription)
  end

  def self.down
    drop_table :database_descriptions
  end
end
