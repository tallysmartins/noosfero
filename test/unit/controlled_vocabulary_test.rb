require File.dirname(__FILE__) + '/../../../../test/test_helper'

class ControlledVocabularyTest < ActiveSupport::TestCase

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

    @controlled_language = ControlledVocabulary.new() 
    @controlled_vocabulary = ControlledVocabulary.new(:administration  => true, :agriculture  => true,  :business_and_services  => true, :communication  => true,
      :culture  => true, :national_defense  => true, :economy_and_finances  => true, :education  => true,
      :energy  => true, :sports  => false , :habitation  => true, :industry  => true, :environment  => true,
      :research_and_development  => true, :social_security  => false , :social_protection  => true,
      :international_relations  => true, :sanitation  => true, :health  => false,
      :security_public_order  => true, :work  => true, :transportation  => true, :urbanism => true)
    @software_info.controlled_vocabulary = @controlled_vocabulary
  end

  should "save software correctly with ControlledVocabulary filds" do
    assert @software_info.save
  end

  should "set in software_info a reference to controlled_vocabulary" do
    @software_info.save
    @controlled_vocabulary.save
    assert_equal SoftwareInfo.last.controlled_vocabulary, ControlledVocabulary.last
  end

  should "return a valid value from database" do
    @software_info.save
    @controlled_vocabulary.save
    software_info = SoftwareInfo.find(@software_info.id)
    controlled_vocabulary = ControlledVocabulary.find(software_info.controlled_vocabulary)
    assert_equal true, controlled_vocabulary.education
  end
end
