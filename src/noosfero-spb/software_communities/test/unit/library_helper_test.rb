require 'test_helper'

class LibraryHelperTest < ActiveSupport::TestCase

  def setup
    @license_objects = [
      {"name" => "license1" ,"version" => "2.0", "license" => "debian", "software_id" => "1"},
      {"name" => "license2" ,"version" => "2.1", "license" => "debian", "software_id" => "1"},
      {"name" => "license3" ,"version" => "2.2", "license" => "debian", "software_id" => "1"}]
  end

  should "return an empty list" do
    empty_list = []
    assert_equal  [],LibraryHelper.list_library(empty_list)
  end

  should "return a list with current library objects" do
    list_compare = []
    lib_table = LibraryHelper.list_library(@license_objects)
    assert_equal  list_compare.class, lib_table.class
  end

  should "have same information from the list passed as parameter" do
    list_compare = LibraryHelper.list_library(@license_objects)
    assert_equal @license_objects.first[:name], list_compare.first.name
  end

  should "return a list with the same size of the parameter" do
    list_compare = LibraryHelper.list_library(@license_objects)
    assert_equal @license_objects.count, list_compare.count
  end

  should "return false if list_database are empty or null" do
    list_compare = []
    assert_equal true, LibraryHelper.valid_list_library?(list_compare)
  end

  should "return a html text with license name equals to linux" do
    libraries = []

    library_description = Library.new
    library_description.name = "Lib"

    libraries << library_description
    lib_table = LibraryHelper.libraries_as_tables(libraries)

    assert_not_nil lib_table.first.call.index("lib")
  end
end
