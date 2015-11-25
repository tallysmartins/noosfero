class RenameCcLicense < ActiveRecord::Migration
  def up
    license = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "CC-GPL-V2"
    unless license.nil?
      license.version = "Creative Commons GPL V2"
      license.save!
    end
  end

  def down
    license = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "Creative Commons GPL V2"
    unless license.nil?
      license.version = "CC-GPL-V2"
      license.save!
    end
  end
end

