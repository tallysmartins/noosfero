class CreateLicenseInfosTable < ActiveRecord::Migration
  def self.up
    create_table :license_infos do |t|
      t.string :version
      t.string :link
    end
  end

  def self.down
    drop_table :license_infos
  end
end
