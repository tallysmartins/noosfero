require 'test_helper'

class SoftwareLanguageHelperTest < ActiveSupport::TestCase

  def setup
    pl1 = ProgrammingLanguage.create(:name => "Python")
    pl2 = ProgrammingLanguage.create(:name => "Java")

    @software_language_objects = [
      {:programming_language_id => pl1.id.to_s ,:version => "2.0"},
      {:programming_language_id => pl2.id.to_s ,:version => "2.1"},
      {:programming_language_id => pl1.id.to_s ,:version => "2.2"}]
    @software_language_objects
  end

  def teardown
    @software_language_objects = nil
    ProgrammingLanguage.destroy_all
  end

  should "return an empty list" do
    empty_list = []
    assert_equal [], SoftwareLanguageHelper.list_language(empty_list)
  end

  should "return a list with current software language objects" do
    list_compare = []
    softwares = SoftwareLanguageHelper.list_language(@software_language_objects)
    assert_equal list_compare.class, softwares.class
  end

  should "have same information from the list passed as parameter" do
    list_compare = SoftwareLanguageHelper.list_language(@software_language_objects)
    lang_id = @software_language_objects.first[:programming_language_id].to_i

    assert_equal lang_id, list_compare.first.programming_language_id
  end

  should "return a list with the same size of the parameter" do
    list_compare = SoftwareLanguageHelper.list_language(@software_language_objects)
    assert_equal @software_language_objects.count, list_compare.count
  end

  should "return false if list_language are empty or null" do
    list_compare = []
    assert_equal false,SoftwareLanguageHelper.valid_list_language?(list_compare)
  end

  should "remove invalid tables from the list" do
    @software_language_objects.push({
      :programming_language_id => "I'm not a valid id",
      :version => "2.0"
    })

    software_language_objects_length = @software_language_objects.count
    list_compare = SoftwareLanguageHelper.list_language(@software_language_objects)

    assert_equal software_language_objects_length-1, list_compare.count
  end
end
