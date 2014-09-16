require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_myprofile_controller'
require File.dirname(__FILE__) + '/software_helper'

class MpogSoftwarePluginMyprofileController; def rescue_action(e) raise e end;
end

class MpogSoftwarePluginMyprofileControllerTest < ActionController::TestCase
  include SoftwareHelper
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
    @hash_list = software_fields
    @software = create_software @hash_list
    @software.community.add_admin(@offer.person) 
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

  should 'create a new software with all fields filled in' do 
    fields = software_fields
    software = create_software(fields)
    assert software.save
  end

private

  def software_fields

    fields = Hash.new
    fields_library = Hash.new
    fields_language = Hash.new
    fields_database = Hash.new
    fields_license = Hash.new
    fields_operating_system = Hash.new
    #Fields for library
    fields_library['version'] = 'test'
    fields_library['name'] = 'test'
    fields_library['license'] = 'test'
    #Fields for software language
    fields_language['version'] = 'test'
    fields_language['programming_language_id'] = ProgrammingLanguage.last.id
    fields_language['operating_system'] = 'test'
    #Fields for database
    fields_database['version'] = 'test'
    fields_database['database_description_id'] = DatabaseDescription.last.id
    fields_database['operating_system'] = 'test'
    #Fields for license info
    fields_license['version'] = 'teste'
    fields_license['link'] = 'teste'
    #Fields for operating system 
    fields_operating_system['version'] = 'version'
    fields_operating_system['operating_system_name_id'] = OperatingSystemName.last.id

    fields['acronym'] = 'test'
    fields['objectives'] = 'test'
    fields['features'] = 'test'
    fields['operating_platform'] = 'operating_plataform_test'
    fields['demonstration_url'] = 'test'

    hash_list = []
    hash_list << fields
    hash_list << fields_library
    hash_list << fields_language
    hash_list << fields_database
    hash_list << fields_operating_system
    hash_list << fields_license
    hash_list
  end
end
