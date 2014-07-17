require File.dirname(__FILE__) + '/../../../../test/test_helper'

class MpogSoftwarePluginValidationTest < ActiveSupport::TestCase
  def setup
    @plugin = MpogSoftwarePlugin.new
    institution = Institution::new(:name => "Test institution")
    institution.save
    @user = fast_create(User)
    @user.institution = institution
  end

  def teardown
    @plugin = nil
    @user = nil
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'return true when the email has gov.br,jus.br,leg.br or mp.br as sufix and role its not empty' do
    @user.secondary_email = "test_email2@net.br"
    @user.email = "test_email@jus.br"
    @user.role = "Team"
    assert @user.save
  end

  should 'return false when the email has gov.br,jus.br,leg.br or mp.br as sufix and role its empty' do
    @user.role = ""
    @user.secondary_email = "test_email@leg.br"
    @user.email = "test_email@mp.br"
    assert !@user.save
  end

  should 'return true when the email has not gov.br,jus.br,leg.br or mp.br' do
    @user.role = ""
    @user.secondary_email = "test_email@com.br"
    @user.email = "test_email@net.br"
    assert @user.save
  end
end
