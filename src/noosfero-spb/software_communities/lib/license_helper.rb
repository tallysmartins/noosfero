module LicenseHelper
  def self.find_licenses query
    licenses = LicenseInfo.where("version ILIKE ?", "%#{query}%").select("id, version")
    licenses.reject!{|license| license.version == "Another"}
    license_another = LicenseInfo.find_by_version("Another")
    licenses << license_another if license_another
    licenses
  end

  def self.all
    licenses = LicenseInfo.without_another.select("id, version")
    put_another_at_the_end licenses
  end

  private

  def self.put_another_at_the_end licenses
    license_another = LicenseInfo.find_by_version("Another")
    licenses << license_another unless license_another.nil?
    licenses
  end
end
