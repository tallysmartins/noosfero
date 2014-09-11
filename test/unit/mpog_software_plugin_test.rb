require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class MpogSoftwarePluginTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = MpogSoftwarePlugin.new
    @user = create_user 'login', 'test@email.com', '1234', '1234', 'test2@email.com'
    @person = @user.person
  end

  def teardown
    @user.person.destroy
    @user.destroy
  end


  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'calculate the percentege of person incomplete fields' do
    @person.name = "Person Name"
    @person.cell_phone = "76888919"

    required_list = ["cell_phone","contact_phone","institution","comercial_phone","country","city","state","organization_website","image"]

    empty_fields = required_list.count - 1
    test_percentege = 100 - ((empty_fields * 100) / required_list.count)

    plugin_percentege = @plugin.calc_percentage_registration(@person)

    assert_equal(test_percentege, plugin_percentege)
	end

  private

  def create_user
    user = User.new
    user.login = "login"
    user.email = "user@email.com"
    user.password = "123456"
    user.password_confirmation = "123456"
    user.secondary_email = "user@secondary_email.com"
    user.save
    user.person.save
    user
  end
end
