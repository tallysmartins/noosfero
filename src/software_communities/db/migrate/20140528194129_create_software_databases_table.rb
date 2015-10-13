class CreateSoftwareDatabasesTable < ActiveRecord::Migration
  def self.up
    create_table :software_databases do |t|
      t.string :version
      t.string :operating_system
      t.references :database_description
      t.references :software_info
    end
  end

  def self.down
    drop_table :software_databases
  end
end
