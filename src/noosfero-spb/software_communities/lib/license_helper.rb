module LicenseHelper
  def self.find_licenses query
    licenses = LicenseInfo.where("version ILIKE ?", "%#{query}%").select("id, version")
    licenses.reject!{|license| license.version == "Another"}
    license_another = LicenseInfo.find_by_version("Another")
    licenses << license_another if license_another
    licenses
  end
end
