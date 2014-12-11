require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareRegistrationTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @environment.enable_plugin(MpogSoftwarePlugin)
  end

  def teardown
    Community.destroy_all
    SoftwareInfo.destroy_all
    Task.destroy_all
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
            :environment => @environment
           )

    software_count = SoftwareInfo.count
    task.finish

    assert_equal software_count+1, SoftwareInfo.count
  end
end
