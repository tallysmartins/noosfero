require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../helpers/software_test_helper'
require(
  File.expand_path(File.dirname(__FILE__)) +
  '/../../../../app/controllers/public/profile_controller'
)

class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < ActionController::TestCase
  include SoftwareTestHelper

  def setup
    @controller =CommunitiesRatingsPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('default_user').person

    LicenseInfo.create(
      :version=>"CC-GPL-V2",
      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    )

    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin', 'CommunitiesRatingsPlugin']
    @admin = create_user("adminuser").person
    @admin.stubs(:has_permission?).returns("true")
    @environment.add_admin(@admin)
    @environment.save

    @software = create_software(software_fields)
  end

  should "dispach additional comment fields when a software is rated" do
    login_as(@admin.name)
    get :new_rating , profile: @software.community.identifier
    assert_template :new_rating
    assert_match(/Additional informations/, @response.body)
  end

  should "DO NOT dispach additional comment fields when the rated community isn't a software" do
    login_as(@admin.name)
    community = fast_create(Community)

    get :new_rating , profile: community.identifier
    assert_template :new_rating
    assert_not_match(/Additional informations/, @response.body)
  end

  should "show additional comment fields on rate list if logged user is a environment admin" do
    login_as(@admin.name)
    seed_avaliations

    get :new_rating , profile: @software.community.identifier

    assert_match("<span>People benefited :</span> 123", @response.body)
    assert_match("<span>Saved Value :</span> 123456.0", @response.body)
  end

  should "show additional comment fields on rate list if logged user is the software admin" do
    seed_avaliations
    login_as(@profile.name)
    @software.community.add_admin @profile

    get :new_rating , profile: @software.community.identifier

    assert_match("<span>People benefited :</span> 123", @response.body)
    assert_match("<span>Saved Value :</span> 123456.0", @response.body)
  end

  should "DO NOT show additional comment fields on rate list if logged user in't a admin" do
    login_as(@profile.name)
    seed_avaliations

    get :new_rating , profile: @software.community.identifier

    assert_not_match("<span>People benefited :</span> 123", @response.body)
    assert_not_match("<span>Saved Value :</span> 123456.0", @response.body)
  end

  private

  def make_avaliation software, person, rate_value, people_benefited, saved_value
    comment = Comment.create! :author=>person, :body=>"simple body", :people_benefited=>people_benefited, :saved_value=>saved_value
    rate = CommunityRating.new :value=>rate_value, :person=>person, :community=>software.community

    rate.comment = comment
    rate.save!
    rate
  end

  def seed_avaliations
    make_avaliation @software, @profile, 1, 123, 123456
    make_avaliation @software, @admin, 2, 456, 789456
  end
end