require 'test_helper'

class OperatingSystemValidationTest < ActiveSupport::TestCase

  def setup
    operating_system_name = SoftwareCommunitiesPlugin::OperatingSystemName::new :name=>"Linux"
    @operating_system = SoftwareCommunitiesPlugin::OperatingSystem::new :version=>"3.0"
    @operating_system.operating_system_name = operating_system_name
    @operating_system
  end

  should "save OperatingSystem if all fields are filled" do
   assert_equal true, @operating_system.save
  end

  should "not save if OperatingSystem does  not have version" do
   @operating_system.version = " "
   assert_equal false, @operating_system.save
  end

  should "not save if OperatingSystem does  not have operating_system_name" do
   @operating_system.operating_system_name = nil
   assert_equal false, @operating_system.save
  end

  should "not save if OperatingSystem have a version too long" do
    @operating_system.version = "A too long version to be a valid"
    assert_equal false, @operating_system.save
  end
end
