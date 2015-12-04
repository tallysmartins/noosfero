require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/software_test_helper'
require(
  File.dirname(__FILE__) +
  '/../../controllers/software_communities_plugin_myprofile_controller'
)

class SoftwareCommunitiesPluginMyprofileController; def rescue_action(e) raise e end;
end

class SoftwareCommunitiesPluginMyprofileControllerTest < ActionController::TestCase
  include SoftwareTestHelper
  def setup
    @controller = SoftwareCommunitiesPluginMyprofileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @person = create_user('person').person
    @offer = create_user('Angela Silva')
    @offer_1 = create_user('Ana de Souza')
    @offer_2 = create_user('Angelo Roberto')

    LicenseInfo.create(
      :version=>"CC-GPL-V2",
      :link=>"http://creativecommons.org/licenses/GPL/2.0/legalcode.pt"
    )

    ProgrammingLanguage.create(:name =>"language")
    DatabaseDescription.create(:name => "database")
    OperatingSystemName.create(:name=>"Debian")

    login_as(@person.user_login)
    @environment = Environment.default
    @environment.enable_plugin('SoftwareCommunitiesPlugin')
    @environment.save!
  end

  attr_accessor :person, :offer

  should 'Add offer to admin in new software' do
    @hash_list = software_fields
    @software = create_software @hash_list
    @software.community.add_admin(@offer.person)
    @software.save
    assert_equal @offer.person.id, @software.community.admins.last.id
  end

  should 'create a new software with all fields filled in' do
    fields = software_fields
    @environment.add_admin(@person)
    post(
      :new_software,
      :profile => @person.identifier,
      :community => fields[1],
      :license => fields[0],
      :software_info => fields[2]
    )
    assert_equal SoftwareInfo.last.community.name, "Debian"
  end

  should 'edit a new software adding basic information' do
    fields_software = software_fields
    fields = software_edit_basic_fields

    software = create_software fields_software
    post(
      :edit_software,
      :profile => software.community.identifier,
      :license => fields[1],
      :software => fields[0],
      :library => {},
      :operating_system => {},
      :language => {},
      :database => {}
    )
    assert_equal SoftwareInfo.last.repository_link, "www.github.com/test"
  end

  should 'edit a new software adding specific information' do
    fields_software = software_fields
    fields = software_edit_specific_fields

    software = create_software fields_software
    post(
      :edit_software,
      :profile => software.community.identifier,
      :library => fields[0],
      :language => fields[1],
      :database => fields[2],
      :operating_system => fields[3],
      :software => fields[4],
      :license => fields[5]
    )
    assert_equal SoftwareInfo.last.acronym, "test"
  end

  should 'only admin upgrade a generic software to a public software' do
    admin_person = create_user('admin').person
    @environment.add_admin(admin_person)

    login_as(admin_person.user_login)
    fields_software = software_fields
    fields = software_edit_specific_fields

    fields[4]['public_software'] = true
    software = create_software fields_software

    post(
      :edit_software,
      :profile => software.community.identifier,
      :operating_system => fields[3],
      :software => fields[4],
    )

    assert SoftwareInfo.last.public_software?
  end

  should 'not upgrade a generic software to a public software if user is not an admin' do
    fields_software = software_fields
    fields = software_edit_specific_fields

    fields[4]['public_software'] = true
    software = create_software fields_software

    post(
      :edit_software,
      :profile => software.community.identifier,
      :software => fields[4]
    )

    refute SoftwareInfo.last.public_software?
  end

  ["e_ping","e_mag","icp_brasil","e_arq","intern"].map do |attr|
    define_method "test_should_#{attr}_not_be_changed_by_not_admin" do
      fields_software = software_fields
      fields = software_edit_specific_fields

      fields[4][attr]=true

      software = create_software fields_software

      post(
        :edit_software,
        :profile => software.community.identifier,
        :software => fields[4]
      )

      refute SoftwareInfo.last.send(attr)
    end
  end

  ["e_ping","e_mag","icp_brasil","e_arq","intern"].map do |attr|
    define_method "test_should_#{attr}_be_changed_by_admin" do
      admin_person = create_user('admin').person
      @environment.add_admin(admin_person)
      login_as(admin_person.user_login)

      fields_software = software_fields
      fields = software_edit_specific_fields

      fields[4][attr]=true

      software = create_software fields_software

      post(
        :edit_software,
        :profile => software.community.identifier,
        :software => fields[4]
      )

      assert SoftwareInfo.last.send(attr)
    end
  end

  should "create software_info with existing license_info" do
    @environment.add_admin(@person)

    post(
      :new_software,
      :community => {:name =>"New Software", :identifier => "new-software"},
      :software_info => {:finality => "something", :repository_link => ""},
      :license =>{:license_infos_id => LicenseInfo.last.id},
      :profile => @person.identifier
    )

    assert_equal SoftwareInfo.last.license_info, LicenseInfo.last
  end

  should "create software_info with 'Another' license_info" do
    license_another = LicenseInfo.create(:version => "Another", :link => "#")
    @environment.add_admin(@person)

    another_license_version = "Different License"
    another_license_link = "http://diferent.link"

    post(
      :new_software,
      :community => { :name => "New Software", :identifier => "new-software" },
      :software_info => { :finality => "something", :repository_link => "" },
      :license => { :license_infos_id => license_another.id,
        :version => another_license_version,
        :link=> another_license_link
      },
      :profile => @person.identifier
    )

    assert_equal license_another.id, SoftwareInfo.last.license_info_id
    assert_equal nil, SoftwareInfo.last.license_info.id
    assert_equal another_license_version, SoftwareInfo.last.license_info.version
    assert_equal another_license_link, SoftwareInfo.last.license_info.link
  end

  should "create software_info after finish task with 'Another' license_info" do
    license_another = LicenseInfo.create(:version => "Another", :link => "#")

    another_license_version = "Different License"
    another_license_link = "http://diferent.link"

    post(
      :new_software,
      :community => { :name => "New Software", :identifier => "new-software" },
      :software_info => { :finality => "something", :repository_link => "" },
      :license => { :license_infos_id => license_another.id,
        :version => another_license_version,
        :link=> another_license_link
      },
      :profile => @person.identifier
    )

    @environment.add_admin(@person)
    Task.last.send('finish', @person)

    assert_equal license_another.id, SoftwareInfo.last.license_info_id
    assert_equal nil, SoftwareInfo.last.license_info.id
    assert_equal another_license_version, SoftwareInfo.last.license_info.version
    assert_equal another_license_link, SoftwareInfo.last.license_info.link
  end

  should "show error messages on create software_info" do
    post(
      :new_software,
      :community => {},
      :software_info => {},
      :license => {},
      :profile => @person.identifier
    )
    assert_includes @response.body, "Domain can't be blank"
    assert_includes @response.body, "Name can't be blank"
    assert_includes @response.body, "Finality can't be blank"
    assert_includes @response.body, "Version can't be blank"
  end

  should "show domain not available error" do
    @environment.add_admin(@person)

    post(
      :new_software,
      :community => {:name =>"New Software", :identifier => "new-software"},
      :software_info => {:finality => "something", :repository_link => ""},
      :license =>{:license_infos_id => LicenseInfo.last.id},
      :profile => @person.identifier
    )
    post(
      :new_software,
      :community => {:name =>"New Software", :identifier => "new-software"},
      :software_info => {:finality => "something", :repository_link => ""},
      :license =>{:license_infos_id => LicenseInfo.last.id},
      :profile => @person.identifier
    )

    assert_includes @response.body, "Domain is not available"
  end

  should "create software with admin moderation" do
    @environment.enable('admin_must_approve_new_communities')

    post(
      :new_software,
      :community => {:name =>"New Software", :identifier => "new-software"},
      :software_info => {:finality => "something", :repository_link => ""},
      :license =>{:license_infos_id => LicenseInfo.last.id},
      :profile => @person.identifier
    )

    @environment.add_admin(@person)
    Task.last.send('finish', @person)

    assert_equal "New Software", Task.last.data[:name]
    assert_equal "New Software", SoftwareInfo.last.community.name
  end

  should "dont create software without accept task" do
    assert_no_difference 'SoftwareInfo.count' do
      post(
        :new_software,
        :community => {:name =>"New Software", :identifier => "new-software"},
        :software_info => {:finality => "something", :repository_link => ""},
        :license =>{:license_infos_id => LicenseInfo.last.id},
        :profile => @person.identifier
      )
    end
 end
end
