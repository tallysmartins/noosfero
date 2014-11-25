require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class MpogSoftwarePluginValidationTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = MpogSoftwarePlugin.new

    @user = fast_create(User)
  end

  def teardown
    @plugin = nil
    @user = nil
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end


  should 'return true when the email has not gov.br,jus.br,leg.br or mp.br' do
    @user.secondary_email = "test_email@com.br"
    @user.email = "test_email@net.br"
    assert @user.save
  end
end
