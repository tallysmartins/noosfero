class RenameCcLicense < ActiveRecord::Migration
  def up
    license = LicenseInfo.find_by_version "CC-GPL-V2"
    license.version = "Creative Commons GPL V2"
    license.save!
  end

  def down
    license = LicenseInfo.find_by_version "Creative Commons GPL V2"
    license.version = "CC-GPL-V2"
    license.save!
  end
end
