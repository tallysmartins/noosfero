require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_myprofile_controller'

class MpogSoftwarePluginMyprofileController; def rescue_action(e) raise e end;
end

class MpogSoftwarePluginMyprofileControllerTest < ActionController::TestCase
  def setup
    @controller = MpogSoftwarePluginMyprofileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @person = create_user('person').person
    @offer = create_user('Angela Silva')
    @offer_1 = create_user('Ana de Souza')
    @offer_2 = create_user('Angelo Roberto')

    LicenseInfo.create(:version=>"CC-GPL-V2", :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt")
    ProgrammingLanguage.create(:name =>"language")
    DatabaseDescription.create(:name => "database")
    OperatingSystemName.create(:name=>"Debian")

    login_as(@person.user.login)
    e = Environment.default
    e.enable_plugin('MpogSoftwarePlugin')
    e.save!
  end

  attr_accessor :person, :offer

  should 'Add offer to admin in new software' do
    community = {
      :name => 'debian'
    }
    software_info = {
      :e_mag => true ,
      :icp_brasil => false,
      :intern => false ,
      :e_ping => false ,
      :e_arq => false,
      :operating_platform =>'operating_plataform_test',
      :demonstration_url => 'test',
      :acronym => 'test',
      :objectives => 'test',
      :features => 'test'
    }
    library = [{
       :name => 'test',
       :version => 'test',
       :license=> 'test'
    },{}]
    operating_system = [{
      :operating_system_name_id => OperatingSystemName.last.id,
      :version => "stable"
    }, {}]
    database = [{
      :database_description_id => DatabaseDescription.last.id,
      :version => 'database version',
      :operating_system => 'database operating_system'
    },{}]
    language = [{
      :programming_language_id => ProgrammingLanguage.last.id,
      :version => 'language version',
      :operating_system => 'language operating_system'
    },{}]

    license_info = {:version => "CC-GPL-V2",:link => "http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"}
    post :new_software, :profile => person.identifier, :community => community, :license_info => license_info,
         :software_info => software_info, :library => library, :database => database,
         :language => language, :operating_system=>operating_system, :q => @offer.id

    assert_equal @offer.id, Community.last.admins.last.id
  end

  should 'search new offers while creating a new software' do
    offer_token = "An"
    post :search_offerers, :profile => person.identifier,:q => offer_token
    response = JSON.parse(@response.body)
    assert_equal "Angelo Roberto",response[0]["name"]
    assert_equal "Ana de Souza",response[1]["name"]
    assert_equal "Angela Silva",response[2]["name"]
  end

  should 'make search for Ang for offerer in software creation' do
    offer_token = "Ang"
    post :search_offerers, :profile => person.identifier,:q => offer_token
    response = JSON.parse(@response.body)
    assert_equal "Angelo Roberto",response[0]["name"]
    assert_equal "Angela Silva",response[1]["name"]
  end

  should 'not find any offerer for software creation' do
    offer_token = "Jos"
    post :search_offerers, :profile => person.identifier,:q => offer_token
    response = JSON.parse(@response.body)
    assert response.count == 0
  end

end
