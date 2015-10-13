require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'
require(
File.dirname(__FILE__) +
'/../../../../app/controllers/public/search_controller'
)

class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.save

    @controller = SearchController.new
    @request = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(:false)
    @response = ActionController::TestResponse.new
  end

  should "communities searches don't have institution" do
    community = create_community("New Community")
    institution = create_private_institution(
    "New Private Institution",
    "NPI" ,
    "Brazil",
    "DF",
    "Gama",
    "66.544.314/0001-63"
    )

    get :communities, :query => "New"

    assert_includes assigns(:searches)[:communities][:results], community
    assert_not_includes assigns(:searches)[:communities][:results], institution.community
  end

  should "institutions_search don't have community" do
    community = create_community("New Community")
    institution = create_private_institution(
    "New Private Institution",
    "NPI" ,
    "Brazil",
    "DF",
    "Gama",
    "66.544.314/0001-63"
    )

    get :institutions, :query => "New"

    assert_includes assigns(:searches)[:institutions][:results], institution.community
    assert_not_includes assigns(:searches)[:institutions][:results], community
  end
end
