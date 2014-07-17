require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_controller'

class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < ActionController::TestCase

  def setup
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
      :role=>"um role ai",
      :institution_id=>@institution_list.last.id
    }

    @profile_data_info = {
      :name=>"Um novo usuario",
      :area_interest=>"uma area ai"
    }
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

  private

  def create_institution name, acronym
    institution = Institution.new
    institution.name = name
    institution.acronym  = acronym
    institution.type = "PublicInstitution"
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
      :role=>"um role ai",
      :institution_id=>@institution_list.last.id
    }

    profile_data = {
      :name=>"Um novo usuario",
      :area_interest=>"uma area ai"
    }

    user["profile_data"] = profile_data
    user
  end
end