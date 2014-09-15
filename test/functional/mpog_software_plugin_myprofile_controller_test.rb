require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) +
'/../../controllers/mark_comment_as_read_plugin_profile_controller'

class MpogSoftwarePluginMyprofileController; def rescue_action(e) raise e end;
end

class MpogSoftwarePluginMyprofileControllerTest < ActionController::TestCase
  def setup
    @controller = MpogSoftwarePluginMyprofileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # @organization = Community.create!(:name => 'My Software', :identifier =>
    # 'my-software')
    @person = create_user('person').person
    #@organization.add_admin(@person)
    login_as(@person.user.login)
    e = Environment.default
    e.enable_plugin('MpogSoftwarePlugin')
    e.save!
  end

  attr_accessor :person

  should 'search new offerers while creating a new software' do
  end

  should 'search new offerers while edting a new software' do
  end
end
