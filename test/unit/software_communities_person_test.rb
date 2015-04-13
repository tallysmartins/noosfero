# encoding: utf-8

require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class GovUserPluginPersonTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = SoftwareCommunitiesPlugin.new

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

  should 'get a list of softwares of a person' do
    software1 = create_software_info "noosfero"
    software2 = create_software_info "colab"
    community = create_community "simple_community"

    software1.community.add_member @person
    software1.save!
    community.add_member @person
    community.save!

    assert_equal 1, @person.softwares.count
  end
end
