module LicenseHelper
  def self.getListLicenses
    LicenseInfo.all
  end
end