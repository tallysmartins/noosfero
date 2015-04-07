require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/software_test_helper'
require File.dirname(__FILE__) + '/../helpers/institution_test_helper'
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

  should 'upgrade a generic software to a public software' do
    fields_software = software_fields
    fields = software_edit_specific_fields

    fields[4]['public_software'] = true
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

    assert_equal true, SoftwareInfo.last.public_software?
  end

  should "user edit its community institution" do
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juridical_nature = JuridicalNature.create(:name => "Autarquia")

    institution = InstitutionTestHelper.create_public_institution(
      "Ministerio Publico da Uniao",
      "MPU",
      "BR",
      "DF",
      "Gama",
      juridical_nature,
      govPower,
      govSphere,
      "12.345.678/9012-45"
    )

    identifier = institution.community.identifier

    fields = InstitutionTestHelper.generate_form_fields(
      "institution new name",
      "BR",
      "DF",
      "Gama",
      "12.345.678/9012-45",
      "PrivateInstitution"
    )

    post(
      :edit_institution,
      :profile=>institution.community.identifier,
      :community=>fields[:community],
      :institutions=>fields[:institutions]
    )

    institution = Community[identifier].institution
    assert_not_equal "Ministerio Publico da Uniao", institution.community.name
  end

  should "not user edit its community institution with wrong values" do
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juridical_nature = JuridicalNature.create(:name => "Autarquia")

    institution = InstitutionTestHelper.create_public_institution(
      "Ministerio Publico da Uniao",
      "MPU",
      "BR",
      "DF",
      "Gama",
      juridical_nature,
      govPower,
      govSphere,
      "12.345.678/9012-45"
    )

    identifier = institution.community.identifier

    fields = InstitutionTestHelper.generate_form_fields(
      "",
      "BR",
      "DF",
      "Gama",
      "6465465465",
      "PrivateInstitution"
    )

    post(
      :edit_institution,
      :profile=>institution.community.identifier,
      :community=>fields[:community],
      :institutions=>fields[:institutions]
    )

    institution = Community[identifier].institution
    assert_equal "Ministerio Publico da Uniao", institution.community.name
    assert_equal "12.345.678/9012-45", institution.cnpj
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

    assert_equal SoftwareInfo.last.license_info_id, license_another.id
    assert_equal SoftwareInfo.last.license_info.id, nil
    assert_equal SoftwareInfo.last.license_info.version, another_license_version
    assert_equal SoftwareInfo.last.license_info.link, another_license_link
  end

end
