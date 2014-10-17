require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareDatabaseTest < ActiveSupport::TestCase

  def setup
    @software_license_info = LicenseInfo.new(:version => "1.0", :link => "www.gpl2.com")
    @software_license_info.id = 1
  end

  should "save if all informations are filled" do
    assert @software_license_info.save, "License Info should have been saved"
  end

  should "not save if license info version is empty" do
    @software_license_info.version = nil
    assert !@software_license_info.save, "Version can't be blank"
  end

  should "save if link is empty" do
    @software_license_info.link = nil
    assert @software_license_info.save, "License info should have been saved"
  end
end
