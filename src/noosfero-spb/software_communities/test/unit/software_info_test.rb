require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareInfoValidationTest < ActiveSupport::TestCase

  include PluginTestHelper

  should "Return original license_info when license is not 'Another'" do
    @software_info = create_software_info("software_test")
    @license_info = create_license_info("license_test")

    @software_info.license_info = @license_info
    @software_info.save!

    assert_equal @software_info.license_info, @license_info
  end

  should "Return license_info with another values" do
    @software_info = create_software_info("software_test")
    @license_another = create_license_info("Another")

    another_license_version = "Another Version"
    another_license_link = "#another_link"

    @software_info.another_license(another_license_version, another_license_link)

    assert_equal @software_info.license_info_id, @license_another.id
    assert_equal @software_info.license_info.version, another_license_version
    assert_equal @software_info.license_info.link, another_license_link
  end

  should "search softwares on the correct environment when multi environments available" do
    software_info = create_software_info("soft1")
    another_software_info = create_software_info("soft2")
    other_env = Environment.create!(name: "sisp")
    another_soft_profile = another_software_info.community
    another_soft_profile.environment_id = other_env.id
    another_soft_profile.save

    assert_equal 2, SoftwareInfo.count
    assert_equal 1, SoftwareInfo.search_by_query("", Environment.default).count
    assert_equal software_info, SoftwareInfo.search_by_query("", Environment.default).first
    assert_equal 1, SoftwareInfo.search_by_query("", other_env).count
    assert_equal true, SoftwareInfo.search_by_query("", other_env).all.include?(another_software_info)
  end

  should "start another license with default values" do
    software_info = create_software_info("software_test")
    license_another = create_license_info("Another")

    software_info.license_info_id = license_another.id

    assert_equal software_info.license_info.version, "Another"
    assert_equal software_info.license_info.link, "#"
  end
end
