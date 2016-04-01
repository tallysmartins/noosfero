require 'test_helper'

class SoftwareRegistrationTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @environment.enable_plugin(SoftwareCommunitiesPlugin)

    @license_info = LicenseInfo.create(:version => "New License", :link => "#")
  end

  should 'include software registration task if is admin' do
    person = create_user('molly').person
    @environment.add_admin(person)
    task = CreateSoftware.create!(
            :name => "Teste One",
            :requestor => person,
            :environment => @environment
           )
    assert_equal [task], Task.to(person).pending
  end

  should 'create software when admin accept software create task' do
    person = create_user('Pedro').person
    @environment.add_admin(person)
    task = CreateSoftware.create!(
            :name => "Teste Two",
            :requestor => person,
            :environment => @environment,
            :finality => "something",
            :license_info => @license_info
           )

    software_count = SoftwareInfo.count
    task.finish

    assert_equal software_count+1, SoftwareInfo.count
  end
end
