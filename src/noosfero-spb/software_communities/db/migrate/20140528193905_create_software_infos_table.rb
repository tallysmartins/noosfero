class CreateSoftwareInfosTable < ActiveRecord::Migration
  def self.up
    create_table :software_infos do |t|
      t.references :license_info
      t.references :community
      t.boolean :e_mag, :default => false
      t.boolean :icp_brasil,:default => false
      t.boolean :intern, :default => false
      t.boolean :e_ping, :default => false
      t.boolean :e_arq, :default => false
      t.string :name, :default => ' '
      t.string :operating_platform
      t.string :demonstration_url
      t.string :acronym
      t.text :objectives
      t.text :features
    end
  end

  def self.down
    drop_table :software_infos
  end
end
