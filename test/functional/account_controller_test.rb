require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_controller'

class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < ActionController::TestCase

  def setup
    environment = Environment.default
    environment.enabled_plugins = ['MpogSoftwarePlugin']
    environment.save

    @gov_power = GovernmentalPower.create(:name=>"Some Gov Power")
    @gov_sphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    @juridical_nature = JuridicalNature.create(:name => "Autarquia")

    @controller = AccountController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @institution_list = []
    @institution_list << create_public_institution("Ministerio Publico da Uniao", "MPU", "BR", "DF", "Gama", @juridical_nature, @gov_power, @gov_sphere)
    @institution_list << create_public_institution("Tribunal Regional da Uniao", "TRU", "BR", "DF", "Brasilia", @juridical_nature, @gov_power, @gov_sphere)
    @user_info = {
      :login=>"novo_usuario",
      :password=>"nova_senha",
      :password_confirmation=>"nova_senha",
      :email=>"um@novo.usuario",
      :secondary_email=>"outro@email.com",
      :institution_ids=>[@institution_list.last.id]
    }

    @second_user_info = {
      :login=>"outro_usuario",
      :password=>"nova_senha",
      :password_confirmation=>"nova_senha",
      :email=>"um_outro@novo.usuario",
      :secondary_email=>"outro2@email.com",
      :institution_ids=>[@institution_list.last.id]
    }

    @profile_data_info = {
      :name=>"Um novo usuario",
      :area_interest=>"uma area ai"
    }

    @second_profile_data_info = {
      :name=>"Um outro usuario",
      :area_interest=>"uma area ai"
    }
    disable_signup_bot_check
  end

  should "Create a user without gov email and institution" do
    @user_info[:institution_ids] = nil

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
    @user_info[:institution_ids] = nil

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


  should "user can become a member of more than one institution" do
    @user_info[:institution_ids] = [@institution_list.first.id, @institution_list.last.id]

    post :signup, :user => @user_info, :profile_data => @profile_data_info

    last_user = User.last

    assert last_user.institutions.include?(@institution_list.first)
    assert last_user.institutions.include?(@institution_list.last)
  end

  should "not create a user with secondary email as someone's primary email" do
    @second_user_info[:secondary_email] = @user_info[:email]

    post :signup, :user => @user_info, :profile_data => @profile_data_info
    post :signup, :user => @second_user_info, :profile_data => @second_profile_data_info
    assert !assigns(:user).save, "This should not have been saved."
  end

  should "not create a user with secondary email as someone's secondary email" do
    @second_user_info[:secondary_email] = @user_info[:secondary_email]

    post :signup, :user => @user_info, :profile_data => @profile_data_info
    post :signup, :user => @second_user_info, :profile_data => @second_profile_data_info
    assert !assigns(:user).save, "This should not have been saved."
  end

  should "not create a user with equal emails" do
    @user_info[:email] = @user_info[:secondary_email]

    post :signup, :user => @user_info, :profile_data => @profile_data_info
    assert !assigns(:user).save, "This should not have been saved."
  end

  should "not create a user with governmental secondary email" do
    @user_info[:secondary_email] = "email@gov.br"

    post :signup, :user => @user_info, :profile_data => @profile_data_info
    assert !assigns(:user).save, "This should not have been saved."
  
  should "user can register without secondary_email" do
    @user_info[:secondary_email] = ""

    post :signup, :user => @user_info, :profile_data => @profile_data_info

    assert_equal assigns(:user).login, @user_info[:login]
    assert assigns(:user).save
  end

  private

  def create_public_institution name, acronym, country, state, city, juridical_nature, gov_p, gov_s
    institution_community = fast_create(Community)
    institution_community.name = name
    institution_community.country = country
    institution_community.state = state
    institution_community.city = city
    institution_community.save!

    institution = PublicInstitution.new
    institution.community = institution_community
    institution.name = name
    institution.juridical_nature = juridical_nature
    institution.acronym = acronym
    institution.governmental_power = gov_p
    institution.governmental_sphere = gov_s
    institution.save!
    institution
  end

  # def form_params
  #   user = {
  #     :login=>"novo_usuario",
  #     :password=>"nova_senha",
  #     :password_confirmation=>"nova_senha",
  #     :email=>"um@novo.usuario",
  #     :secondary_email=>"outro@email.com",
  #     :institution_ids=>[@institution_list.last.id]
  #   }

  #   profile_data = {
  #     :name=>"Um novo usuario",
  #     :area_interest=>"uma area ai"
  #   }

  #   user["profile_data"] = profile_data
  #   user
  # end

  def disable_signup_bot_check(environment = Environment.default)
    environment.min_signup_delay = 0
    environment.save!
  end
end
