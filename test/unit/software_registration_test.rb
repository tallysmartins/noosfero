require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareRegistrationTest < ActiveSupport::TestCase

  def setup
    @community = Community.new(:name => "test")
    @community.save
    @atributes = {}
    #@license_info = LicenseInfo::new
    @atributes = {:name => @community.name}
    @environment = Environment.default
    @environment.enable_plugin(MpogSoftwarePlugin)
  end

  should 'include software registration task if is admin' do
    person = create_user('molly').person
    @environment.add_admin(person)
    task = CreateSoftware.create!(@atributes.merge(:requestor => person,:environment => @environment))
    Person.any_instance.stubs(:is_admin?).returns(true)
    assert_equal [task], Task.to(person).pending
  end
end
