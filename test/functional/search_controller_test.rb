require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../../../app/controllers/public/search_controller'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['MpogSoftwarePlugin']
    @environment.save

    @controller = SearchController.new
    @request = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(:false)
    @response = ActionController::TestResponse.new

    @category_software = Category.create!(:name => _("Software"), :environment => @environment)
  end

  should "communities searches don't have software or institution" do
    community = create_community("New Community")
    software = create_software_info("New Software")
    institution = create_private_institution("New Private Institution", "NPI" , "Brazil", "DF", "Gama", "66.544.314/0001-63")

    get :communities, :query => "New"

    assert_includes assigns(:searches)[:communities][:results], community
    assert_not_includes assigns(:searches)[:communities][:results], software
    assert_not_includes assigns(:searches)[:communities][:results], institution
  end

  should "software_infos search don't have community or institution" do
    community = create_community("New Community")
    software = create_software_info("New Software")
    institution = create_private_institution("New Private Institution", "NPI" , "Brazil", "DF", "Gama", "66.544.314/0001-63")

    get :software_infos, :query => "New"

    assert_includes assigns(:searches)[:software_infos][:results], software.community
    assert_not_includes assigns(:searches)[:software_infos][:results], community
    assert_not_includes assigns(:searches)[:software_infos][:results], institution.community
  end

  should "software_infos search by category" do
    software_with_category = create_software_info("New Software With Category")
    software_without_category = create_software_info("New Software Without Category")
    category = Category.create!(:name => "Health", :environment => @environment, :parent => @category_software)

    software_with_category.community.categories << category
    software_with_category.save!

    get :software_infos, :query => "New", :filter => category.id

    assert_includes assigns(:searches)[:software_infos][:results], software_with_category.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_without_category.community
  end

end
