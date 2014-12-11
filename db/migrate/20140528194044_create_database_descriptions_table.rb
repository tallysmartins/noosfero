class CreateDatabaseDescriptionsTable < ActiveRecord::Migration
  def self.up
    create_table :database_descriptions do |t|
      t.string :name
    end

    PATH_TO_FILE="plugins/mpog_software/public/static/databases.txt"
    SoftwareHelper.create_list_with_file(PATH_TO_FILE, DatabaseDescription)
  end

  def self.down
    drop_table :database_descriptions
  end
end
