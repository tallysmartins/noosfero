require 'test_helper'

class LicenseHelperTest < ActiveSupport::TestCase

  def setup
    test_data = [
      {:version=>"GNU 1", :link=>"#gnu-1"},
      {:version=>"GNU 2", :link=>"#gnu-2"},
      {:version=>"GNU 3", :link=>"#gnu-3"},
      {:version=>"Another", :link=>"#another"}
    ]
    test_data.each {|data| SoftwareCommunitiesPlugin::LicenseInfo.create! data}
  end

  should "find licenses by its version with another at the end" do
    another = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "Another"
    gnu_3 = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "GNU 3"
    licenses = SoftwareCommunitiesPlugin::LicenseHelper.find_licenses "3"

    assert_equal gnu_3, licenses.first
    assert_equal another, licenses.last
  end

  should "get all licenses with another at the end" do
    another = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "Another"
    licenses = SoftwareCommunitiesPlugin::LicenseInfo.all

    assert_equal 4, licenses.count
    assert_equal another, licenses.last
  end
end
