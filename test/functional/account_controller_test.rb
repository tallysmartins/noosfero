require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_controller'

class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < ActionController::TestCase

  def setup
    environment = Environment.default
    environment.enabled_plugins = ['MpogSoftwarePlugin']
    environment.save

    @govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    @govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")

    @controller = AccountController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @institution_list = []
    @institution_list << create_institution("Ministerio Publico da Uniao", "MPU")
    @institution_list << create_institution("Tribunal Regional da Uniao", "TRU")

    @user_info = {
      :login=>"novo_usuario",
      :password=>"nova_senha",
      :password_confirmation=>"nova_senha",
      :email=>"um@novo.usuario",
      :secondary_email=>"outro@email.com",
      :institution_id=>@institution_list.last.id
    }

    @profile_data_info = {
      :name=>"Um novo usuario",
      :area_interest=>"uma area ai"
    }

    disable_signup_bot_check
  end

  should "Create a user without gov email and institution" do
    @user_info[:institution_id] = nil

    post :signup, :user => @user_info, :profile_data => @profile_data_info

    assert_equal assigns(:user).login, @user_info[:login]
    assert assigns(:user).save
  end

  should "Create a user with gov email and institution" do
    @user_info[:email] = "email@gov.br"

    post :signup, :user => @user_info, :profile_data => @profile_data_info

    assert_equal assigns(:user).login, @user_info[:login]
    assert assigns(:user).save
  end

  should "Do not create a user with gov email without institution" do
    @user_info[:email] = "email@gov.br"
    @user_info[:institution_id] = nil

    post :signup, :user => @user_info, :profile_data => @profile_data_info

    assert_equal assigns(:user).login, @user_info[:login]
    assert !assigns(:user).save
  end

  should "user become a member of its institution community on registration" do
    post :signup, :user => @user_info, :profile_data => @profile_data_info

    last_user = User.last
    last_community = Community.last

    assert_equal @user_info[:secondary_email], last_user.secondary_email
    assert_equal true, last_community.members.include?(last_user.person)
    assert_response :success
  end

  private

  def create_institution name, acronym
    institution_community = Community::create :name=>name
    institution = PublicInstitution.new
    institution.community = institution_community
    institution.name = name
    institution.acronym  = acronym
    institution.governmental_power = @govPower
    institution.governmental_sphere = @govSphere
    institution.save
    institution
  end

  def form_params
    user = {
      :login=>"novo_usuario",
      :password=>"nova_senha",
      :password_confirmation=>"nova_senha",
      :email=>"um@novo.usuario",
      :secondary_email=>"outro@email.com",
      :institution_id=>@institution_list.last.id
    }

    profile_data = {
      :name=>"Um novo usuario",
      :area_interest=>"uma area ai"
    }

    user["profile_data"] = profile_data
    user
  end

  def disable_signup_bot_check(environment = Environment.default)
    environment.min_signup_delay = 0
    environment.save!
  end
end
