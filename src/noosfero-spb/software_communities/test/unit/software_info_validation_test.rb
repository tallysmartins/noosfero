require 'test_helper'

class SoftwareInfoValidationTest < ActiveSupport::TestCase

  def setup
    @community = fast_create(
                  Community,
                  :identifier => 'new-software',
                  :name => 'New Software'
                )

    @language = ProgrammingLanguage.new(:name => 'C++')
    @language.save
    @software_language = SoftwareLanguage.new(
                          :version => '1'
                        )
    @software_language.programming_language = @language
    @software_language.save

    @database = DatabaseDescription.new(:name => 'Oracle')
    @database.save
    @software_database = SoftwareDatabase.new(
                          :version => '2'
                        )
    @software_database.database_description = @database
    @software_database.save

    @operating_system_name = OperatingSystemName.new(:name => 'Debian')
    @operating_system_name.save
    @operating_system = OperatingSystem.new(:version => '1.0')
    @operating_system.operating_system_name = @operating_system_name
    @operating_system.save

    @license_info = LicenseInfo.create(:version => 'New License', :link => '#')

    @software_info = SoftwareInfo.new(
                      :acronym => "SFTW",
                      :e_mag => true,
                      :icp_brasil => true,
                      :intern => true,
                      :e_ping => true,
                      :e_arq => true,
                      :operating_platform => true,
                      :objectives => "",
                      :features => "",
                      :finality => "something",
                      :license_info => @license_info
                    )
    @software_info.software_languages << @software_language
    @software_info.software_databases << @software_database
    @software_info.operating_systems << @operating_system

    @software_info.features = "Do a lot of things"
    @software_info.objectives = "All tests should pass !"
    @software_info.community = @community
  end

  should 'Save SoftwareInfo if all fields are filled' do
    assert_equal true, @software_info.save
  end

  should 'Save SoftwareInfo if operating_platform is blank' do
    @software_info.operating_platform = ''
    assert_equal true, @software_info.save
  end

  should 'Save SoftwareInfo without demonstration_url be filled' do
    @software_info.demonstration_url = ''
    assert_equal true, @software_info.save
  end

  should "Save SoftwareInfo if acronym is blank" do
    @software_info.acronym = ""

    assert_equal true, @software_info.save
  end

  should "Not save SoftwareInfo if acronym has more than 8 characters" do
    @software_info.acronym = "12345678901"
    assert_equal false, @software_info.save
  end

  should "Save SoftwareInfo if acronym has whitespaces" do
    @software_info.acronym = "AC DC"
    assert_equal false, @software_info.save
  end

  should "Save if objectives are empty" do
    @software_info.objectives = ""

    assert_equal true, @software_info.save
  end

  should "Save if features are empty" do
    @software_info.features = ""

    assert_equal true, @software_info.save
  end

  should "Not save if features are longer than 4000" do
    @software_info.features = "a"*4001
    error_msg = _("Features is too long (maximum is 4000 characters)")

    assert_equal false, @software_info.save
    assert_equal true, @software_info.errors.full_messages.include?(error_msg)
  end

  should "Not save if objectives are longer than  4000" do
    @software_info.objectives = "a"*4001
    error_msg = _("Objectives is too long (maximum is 4000 characters)")

    assert_equal false, @software_info.save
    assert_equal true, @software_info.errors.full_messages.include?(error_msg)
  end

  should "not save software without license" do
    @software_info.license_info = nil

    assert_equal false, @software_info.save
  end
end
