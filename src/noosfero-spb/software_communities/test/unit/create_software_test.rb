require File.dirname(__FILE__) + '/../../../../test/test_helper'

class CreateSoftwareTest < ActiveSupport::TestCase

  def setup
    @requestor = create_user('testuser').person
  end

  should 'be a task' do
    ok { CreateSoftware.new.kind_of?(Task) }
  end

  should 'require a requestor' do
    task = CreateSoftware.new(:name => 'Software Test', :target => Environment.default)
    task.valid?

    assert task.errors[:requestor_id.to_s].present?
    assert task.errors[:finality.to_s].present?
    task.requestor = @requestor
    task.finality = "Any"
    task.valid?
    refute task.errors[:requestor_id.to_s].present?
    refute task.errors[:finality.to_s].present?
  end

  should 'actually create new software community when confirmed' do
    task = CreateSoftware.create!(:name => 'Software Test', :target => Environment.default, :requestor => @requestor, :finality => "Any")

    assert_difference 'SoftwareInfo.count' do
      assert_difference 'Community.count' do
        task.finish
      end
    end

    assert_equal @requestor, Community['software-test'].admins.first
  end

  should 'create new software community with all informed data when confirmed' do
    task = CreateSoftware.create!(:name => 'Software Test', :target => Environment.default, :requestor => @requestor, :finality => "Any", :repository_link => "#", )

    task.finish
    software = Community["software-test"].software_info

    assert_equal "Any", software.finality
    assert_equal "#", software.repository_link
    assert_equal "Software Test", software.community.name
  end

  should 'override message methods from Task' do
    task = CreateSoftware.create!(:name => 'Software Test', :target => Environment.default, :requestor => @requestor, :finality => "Any")

    task.finish

    %w[ target_notification_description target_notification_message task_created_message task_finished_message task_cancelled_message ].each do |method|
      assert_nothing_raised NotImplementedError do
        task.send(method)
      end
    end
  end

  should 'report as approved when approved' do
    request = CreateSoftware.new
    request.stubs(:status).returns(Task::Status::FINISHED)
    assert request.approved?
  end

  should 'report as rejected when rejected' do
    request = CreateSoftware.new
    request.stubs(:status).returns(Task::Status::CANCELLED)
    assert request.rejected?
  end
end
