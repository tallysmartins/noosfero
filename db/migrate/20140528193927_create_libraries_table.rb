class CreateLibrariesTable < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :name
      t.string :version
      t.string :license
      t.references :software_info
    end
  end

  def self.down
    drop_table :libraries
  end
end
