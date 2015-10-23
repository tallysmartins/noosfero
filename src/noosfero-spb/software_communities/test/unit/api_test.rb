require File.dirname(__FILE__) + '/../../../../test/unit/api/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareCommunitiesApiTest < ActiveSupport::TestCase

  include PluginTestHelper

  def setup
    login_api
    environment = Environment.default
    environment.enable_plugin(SoftwareCommunitiesPlugin)
  end

  should 'list all softwares' do
    @software_info = create_software_info("software_test")
    @software_info2 = create_software_info("software_test2")

    get "/api/v1/software_communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [@software_info.id, @software_info2.id], json['softwares'].map {|c| c['software_info']['id']}
  end

  should 'get software by id' do
    @software_info = create_software_info("software_test")
    get "/api/v1/software_communities/#{@software_info.id}?#{params.to_query}"

    json = JSON.parse(last_response.body)
    assert_equal @software_info.id, json["software"]['software_info']["id"]
  end

end
