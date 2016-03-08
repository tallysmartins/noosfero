module SoftwareCommunitiesPlugin::LicenseHelper
  def self.find_licenses query
    licenses = SoftwareCommunitiesPlugin::LicenseInfo.where("version ILIKE ?", "%#{query}%").select("id, version")
    licenses = licenses.reject { |license| license.version == "Another" }
    license_another = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version("Another")
    licenses << license_another if license_another
    licenses
  end
end
