require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareInfoValidationTest < ActiveSupport::TestCase

  def setup
    @community = fast_create(Community, :identifier => 'new-software', :name => 'New Software')

    @language = ProgrammingLanguage.new(:name => 'C++')
    @language.save
    @software_language = SoftwareLanguage.new(:version => '1', :operating_system => 'os')
    @software_language.programming_language = @language
    @software_language.save

    @database = DatabaseDescription.new(:name => 'Oracle')
    @database.save
    @software_database = SoftwareDatabase.new(:version => '2', :operating_system => 'os2')
    @software_database.database_description = @database
    @software_database.save

    @operating_system_name = OperatingSystemName.new(:name => 'Debian')
    @operating_system_name.save
    @operating_system = OperatingSystem.new(:version => '1.0')
    @operating_system.operating_system_name = @operating_system_name
    @operating_system.save

    @software_info = SoftwareInfo.new(:acronym => "SFTW", :e_mag => true,:icp_brasil => true,:intern => true,:e_ping => true,
     :e_arq => true, :operating_platform => true, :objectives => "", :features => "")
    @software_info.software_languages << @software_language
    @software_info.software_databases << @software_database
    @software_info.operating_systems << @operating_system

  end

  should 'Save SoftwareInfo if all fields are filled' do
    assert_equal true, @software_info.save
  end

  should 'Not save SoftwareInfo if operating_platform is blank' do
    @software_info.operating_platform = ''
    assert_equal false, @software_info.save
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

  should "Not save SoftwareInfo if acronym has whitespaces" do
    @software_info.acronym = "AC DC"
    assert_equal false, @software_info.save
  end
end
