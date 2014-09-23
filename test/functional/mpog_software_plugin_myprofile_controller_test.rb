require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/mpog_software_plugin_myprofile_controller'
require File.dirname(__FILE__) + '/software_test_helper'

class MpogSoftwarePluginMyprofileController; def rescue_action(e) raise e end;
end

class MpogSoftwarePluginMyprofileControllerTest < ActionController::TestCase
  include SoftwareTestHelper
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
    @e = Environment.default
    @e.enable_plugin('MpogSoftwarePlugin')
    @e.save!
  end

  attr_accessor :person, :offer

  should 'Add offer to admin in new software' do
    @hash_list = software_fields
    @software = create_software @hash_list
    @software.community.add_admin(@offer.person)
    @software.save
    assert_equal @offer.id, @software.community.admins.last.id
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
    post :new_software, :profile => person.identifier, :community => fields[6], :license_info => fields[5],
                        :software_info => fields[0], :library => fields[1], :database => fields[3],
                        :language => fields[2], :operating_system=> fields[4]

    assert_equal SoftwareInfo.last.name, "Debian"
  end




end
