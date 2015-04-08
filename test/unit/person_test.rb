require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareCommunitiesPluginPersonTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @plugin = GovUserPlugin.new

    @user = fast_create(User)
    @person = create_person(
                "My Name",
                "user@email.com",
                "123456",
                "123456",
                "user@secondaryemail.com",
                "Any State",
                "Some City"
              )
  end

  should 'calculate the percentege of person incomplete fields' do
    @person.cell_phone = "76888919"
    @person.contact_phone = "987654321"

    assert_equal(67, @plugin.calc_percentage_registration(@person))

    @person.comercial_phone = "11223344"
    @person.country = "I dont know"
    @person.state = "I dont know"
    @person.city = "I dont know"
    @person.organization_website = "www.whatever.com"
    @person.image = Image::new :uploaded_data=>fixture_file_upload('/files/rails.png', 'image/png')
    @person.save

    assert_equal(100, @plugin.calc_percentage_registration(@person))
  end

  should 'return true when the email has not gov.br,jus.br,leg.br or mp.br' do
    @user.secondary_email = "test_email@com.br"
    @user.email = "test_email@net.br"
    assert @user.save
  end
end
