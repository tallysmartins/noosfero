require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareLanguageValidationTest < ActiveSupport::TestCase
  def setup
    create_programming_language
    @software_info = create_software_info
    @software_info.save
  end

  def teardown
    @software_info = nil
    SoftwareInfo.destroy_all
  end

  should "Save SoftwareLanguage if version and programming_language are filled" do
    @software_language = create_software_language
    assert_equal true, @software_language.save
  end

  should "Don't save SoftwareLanguage if programming_language is not filed" do
    @software_language = create_software_language
    @software_language.programming_language = nil
    assert_equal true, !@software_language.save
  end

  should "Don't save SoftwareLanguage if version is not filed" do
    @software_language = create_software_language
    @software_language.version = ""
    assert_equal true, !@software_language.save
  end

  should "Don't save SoftwareLanguage if version is too long" do
    @software_language = create_software_language
    @software_language.version = "A too long version to be considered valid as a version"
    assert_equal true, !@software_language.save
  end

  should "Don't save SoftwareLanguage if operating system is too long" do
    @software_language = create_software_language
    @software_language.operating_system = "A too long operating system to be considered valid as a operating system"
    assert_equal true, !@software_language.save
  end

  should "Save SoftwareLanguage if operating_system is not filed" do
    @software_language = create_software_language
    @software_language.operating_system = ""
    assert_equal false, @software_language.save
  end

  private

  def create_software_language
    software_language = SoftwareLanguage.new
    software_language.software_info = @software_info
    software_language.programming_language = ProgrammingLanguage.last
    software_language.version = "version"
    software_language.operating_system = "GNU/Linux"
    software_language
  end

  def create_software_info
    software_info = SoftwareInfo.new
    software_info.community_id = fast_create(Community).id
    software_info.community.name = 'Noosfero'
    software_info.e_mag = true
    software_info.icp_brasil = true
    software_info.intern = true
    software_info.e_ping = true
    software_info.e_arq = true
    software_info.operating_platform = 'GNU/Linux'
    software_info.features = "Do a lot of things"
    software_info.objectives = "All tests should pass !"
    software_info
  end

  def create_programming_language
    ProgrammingLanguage.create(:name=>"C")
    ProgrammingLanguage.create(:name=>"C++")
    ProgrammingLanguage.create(:name=>"Ruby")
    ProgrammingLanguage.create(:name=>"Python")
  end
end
