require File.dirname(__FILE__) + '/../../../../test/test_helper'

class InstitutionHelperTest < ActionController::IntegrationTest

  def setup
    admin = create_user("test_admin").person
    admin.stubs(:has_permission?).returns("true")

    @environment = Environment.default
    @environment.enabled_plugins = ['MpogSoftwarePlugin']
    @environment.add_admin(admin)
    @environment.name = "test_environment"
    @environment.save
  end

  should "not proceed with SIORG script if environment name isn't the informed" do
    assert !InstitutionHelper.mass_update
  end

  should "not proceed with SIORG script if admin name isn't the informed" do
    @environment.name = "Noosfero"
    @environment.save

    assert !InstitutionHelper.mass_update
  end
end
