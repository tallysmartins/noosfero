class CreateDatabaseDescriptionsTable < ActiveRecord::Migration
  def self.up
    create_table :database_descriptions do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :database_descriptions
  end
end
