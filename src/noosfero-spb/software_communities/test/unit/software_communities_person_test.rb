# encoding: utf-8

require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class GovUserPluginPersonTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @plugin = SoftwareCommunitiesPlugin.new

    @user = create_user(
      "user",
      "user@email.com",
      "123456",
      "123456"
    )
  end

  should 'get a list of softwares of a person' do
    software1 = create_software_info "noosfero"
    software2 = create_software_info "colab"
    community = create_community "simple_community"

    software1.community.add_member @user.person
    software1.save!
    community.add_member @user.person
    community.save!

    assert_equal 1, @user.person.softwares.count
  end
end
