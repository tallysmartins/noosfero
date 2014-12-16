# encoding: utf-8

require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class MpogSoftwarePluginPersonTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = MpogSoftwarePlugin.new

    @user = fast_create(User)
    @person = create_person(
                "My Name",
                "user@email.com",
                "123456",
                "123456",
                "user@secondary_email.com",
                "Any State",
                "Some City"
              )
  end

  def teardown
    @plugin = nil
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end


  should 'return true when the email has not gov.br,jus.br,leg.br or mp.br' do
    @user.secondary_email = "test_email@com.br"
    @user.email = "test_email@net.br"
    assert @user.save
  end

  should 'save person with a valid full name' do
    p = Person::new :name=>"S1mpl3 0f N4m3", :identifier=>"simple-name"
    p.user = fast_create(:user)

    assert_equal true, p.save
  end

  should 'save person with a valid full name with accents' do
    name = 'Jônatàs dâ Sîlvã Jösé'
    identifier = "jonatas-jose-da-silva"
    p = Person::new :name=>name, :identifier=>identifier
    p.user = fast_create(:user)

    assert_equal true, p.save
  end

  should 'not save person whose name has not capital letter' do
    p = Person::new :name=>"simple name"
    assert !p.save, _("Name Should begin with a capital letter and no special characters")
  end

  should 'not save person whose name has special characters' do
    p = Person::new :name=>"Simple N@me"

    assert !p.save , _("Name Should begin with a capital letter and no special characters")
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
end