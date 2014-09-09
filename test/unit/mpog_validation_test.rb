require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class MpogSoftwarePluginValidationTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = MpogSoftwarePlugin.new

    institution = build_institution("Test institution")
    institution.save

    @user = fast_create(User)
    @user.institutions << institution
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

  private

  def build_institution name, type="PublicInstitution", cnpj=nil
    institution = Institution::new
    institution.name = name
    institution.type = type
    institution.cnpj = cnpj

    institution.community = Community.create(:name => "Simple Public Institution")
    institution.community.country = "BR"
    institution.community.state = "DF"
    institution.community.city = "Gama"

    if type == "PublicInstitution"
      institution.juridical_nature = JuridicalNature.first
    end

    institution
  end
end
