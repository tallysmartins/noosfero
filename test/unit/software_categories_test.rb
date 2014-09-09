require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareCategoriesTest < ActiveSupport::TestCase

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

    @software_info.features = "Do a lot of things"
    @software_info.objectives = "All tests should pass !"

    @software_categories = SoftwareCategories.new(:administration  => true, :agriculture  => true,  :business_and_services  => true, :communication  => true,
      :culture  => true, :national_defense  => true, :economy_and_finances  => true, :education  => true,
      :energy  => true, :sports  => false , :habitation  => true, :industry  => true, :environment  => true,
      :research_and_development  => true, :social_security  => false , :social_protection  => true,
      :international_relations  => true, :sanitation  => true, :health  => false,
      :security_public_order  => true, :work  => true, :transportation  => true, :urbanism => true)
    @software_info.software_categories = @software_categories
  end

  should "save software correctly with SoftwareCategories filds" do
    assert @software_info.save
  end

  should "set in software_info a reference to software_categories" do
    @software_info.save
    @software_categories.save
    assert_equal SoftwareInfo.last.software_categories, SoftwareCategories.last
  end

  should "return a valid value from database" do
    @software_info.save
    @software_categories.save
    software_info = SoftwareInfo.find(@software_info.id)
    software_categories = SoftwareCategories.find(software_info.software_categories)
    assert_equal true, software_categories.education
  end
end
