require 'test_helper'

class LicenseInfoTest < ActiveSupport::TestCase

  should "save if all informations are filled" do
    @software_license_info = SoftwareCommunitiesPlugin::LicenseInfo.create(
                              :version => "GPL",
                              :link => "www.gpl2.com"
                            )
    assert @software_license_info.save!, "License Info should have been saved"
  end

  should "not save if license info version is empty" do
    @software_license_info = SoftwareCommunitiesPlugin::LicenseInfo.create(
                              :version => "GPL",
                              :link => "www.gpl2.com"
                            )
    @software_license_info.version = nil
    assert !@software_license_info.save, "Version can't be blank"
  end

  should "save if link is empty" do
    @software_license_info = SoftwareCommunitiesPlugin::LicenseInfo.create(
                              :version => "GPL",
                              :link => "www.gpl2.com")
    @software_license_info.link = nil
    assert @software_license_info.save, "License info should have been saved"
  end

  should "scope without_another get all licenses expect for Another" do
    test_data = [
      {:version=>"GNU 1", :link=>"#"},
      {:version=>"GNU 2", :link=>"#"},
      {:version=>"GNU 3", :link=>"#"},
      {:version=>"Another", :link=>"#"}
    ]
    test_data.each {|data| SoftwareCommunitiesPlugin::LicenseInfo.create! data}

    another = SoftwareCommunitiesPlugin::LicenseInfo.find_by_version "Another"

    assert_not_nil another
    assert !SoftwareCommunitiesPlugin::LicenseInfo.without_another.include?(another), "Scope without_another shoud get all except for another"
  end
end
