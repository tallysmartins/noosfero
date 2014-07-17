class CreateDatabaseDescriptionsTable < ActiveRecord::Migration
  def self.up
    create_table :database_descriptions do |t|
      t.string :name
    end

    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/databases.txt", DatabaseDescription)
  end

  def self.down
    drop_table :database_descriptions
  end
end
