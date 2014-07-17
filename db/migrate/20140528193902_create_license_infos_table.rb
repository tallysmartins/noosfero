class CreateLicenseInfosTable < ActiveRecord::Migration
  def self.up
    create_table :license_infos do |t|
      t.string :version
      t.string :link
    end
    LicenseInfo.create(:version=>"CC-GPL-V2", :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt")
  end

  def self.down
    drop_table :license_infos
  end
end
