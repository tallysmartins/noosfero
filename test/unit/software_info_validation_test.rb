require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareInfoValidationTest < ActiveSupport::TestCase

  def setup
    @community = fast_create(Community)
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
     @software_info = SoftwareInfo.new(:community_id=>1, :acronym => "SFTW", :e_mag => true,:icp_brasil => true,:intern => true,:e_ping => true,
     :e_arq => true,:name => true,:operating_platform => true,:objectives => "",:features => "")
     @software_info.software_languages << @software_language
     @software_info.software_databases << @software_database
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

  should "Not save SoftwareInfo if acronym is blank" do
    @software_info.acronym = ""
    assert_equal false, @software_info.save
  end

  should "Not save SoftwareInfo if acronym has more than 8 characters" do
    @software_info.acronym = "123456789"
    assert_equal false, @software_info.save
  end
end
