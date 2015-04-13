# encoding: utf-8

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
end
