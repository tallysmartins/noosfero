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
    @environment.enabled_plugins = ['MpogSoftwarePlugin']
    @environment.save

    @controller = SearchController.new
    @request = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(:false)
    @response = ActionController::TestResponse.new

    create_software_categories
  end

  should "communities searches don't have software or institution" do
    community = create_community("New Community")
    software = create_software_info("New Software")
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
    assert_not_includes assigns(:searches)[:communities][:results], software
    assert_not_includes assigns(:searches)[:communities][:results], institution
  end

  should "software_infos search don't have community or institution" do
     community = create_community("New Community")
     software = create_software_info("New Software")
     institution = create_private_institution("New Private Institution", "NPI" , "Brazil", "DF", "Gama", "66.544.314/0001-63")

     software.license_info = LicenseInfo.create :version=>"GPL - 1.0"
     software.save!

     get :software_infos, :query => "New"

     assert_includes assigns(:searches)[:software_infos][:results], software.community
     assert_not_includes assigns(:searches)[:software_infos][:results], community
     assert_not_includes assigns(:searches)[:software_infos][:results], institution.community
  end


  should "Don't found template in communities search" do
    community = create_community("New Community")
    software = create_software_info("New Software")
    software.license_info = LicenseInfo.create(:version => "GPL")
    software.save!

    institution = create_private_institution(
      "New Private Institution",
      "NPI" ,
      "Brazil",
      "DF",
      "Gama",
      "66.544.314/0001-63"
    )

    community_template = create_community("New Community Template")
    community_template.is_template = true
    community_template.save!

    get :communities, :query => "New"

    assert_not_includes(
      assigns(:searches)[:communities][:results],
      community_template
    )
  end

  should "institutions_search don't have community or software" do
    community = create_community("New Community")
    software = create_software_info("New Software")
    institution = create_private_institution(
      "New Private Institution",
      "NPI" ,
      "Brazil",
      "DF",
      "Gama",
      "66.544.314/0001-63"
    )

    get :institutions, :query => "New"

    assert_includes(
      assigns(:searches)[:institutions][:results],
      institution.community
    )
    assert_not_includes assigns(:searches)[:institutions][:results], community
    assert_not_includes(
      assigns(:searches)[:institutions][:results],
      software.community
    )
  end

  should "software_infos search by category" do
    software_one = create_software_info("Software One")
    software_two = create_software_info("Software Two")

    software_one.community.categories << Category.first
    software_two.community.categories << Category.last

    software_one.license_info = LicenseInfo.create :version=>"GPL - 1.0"
    software_two.license_info = LicenseInfo.create :version=>"GPL - 1.0"

    software_one.save!
    software_two.save!

    get(
      :software_infos,
      :query => "",
      :selected_categories => [Category.first.id]
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_one.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_two.community
  end

  private

  def create_software_categories
    category_software = Category.create!(
      :name => "Software",
      :environment => @environment
    )
    Category.create(
      :name => "Category One",
      :environment => @environment,
      :parent => category_software
    )
    Category.create(
      :name => "Category Two",
      :environment => @environment,
      :parent => category_software
    )
  end
end
