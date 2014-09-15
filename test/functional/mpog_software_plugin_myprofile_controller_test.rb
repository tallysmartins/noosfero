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
    LicenseInfo.create(:version=>"CC-GPL-V2",
:link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt")
    login_as(@person.user.login)
    e = Environment.default
    e.enable_plugin('MpogSoftwarePlugin')
    e.save!
  end

  attr_accessor :person

  should 'create new_software' do
    community = {
          :name => 'debian'
        }
        software_info = {
          :e_mag => true ,  
          :icp_brasil => false,
          :intern => false ,
          :e_ping => false ,
          :e_arq => false,
          :name =>'test',
          :operating_platform =>'test', 
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
        database = [{
          :name => 'mysql'
        },{}]
        language = [{
          :version => 'test',
          :operating_system => 'test' 
        },{}]

        license_info = {:version => "CC-GPL-V2",:link => "http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"}
        post :new_software, :profile => person.identifier, :community => community, :license_info => license_info, 
             :software_info => software_info, :library => library, :database => database, :language => language
  end
end
