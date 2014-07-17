require File.dirname(__FILE__) + '/../../../../test/test_helper'

class DatabaseHelperTest < ActiveSupport::TestCase

  include DatabaseHelper

  def setup
    @database_objects = [{"database_description_id" => "1" ,"version" => "2.0", "operating_system" => "debian"},
      {"database_description_id" => "2" ,"version" => "2.1", "operating_system" => "debian"},
      {"database_description_id" => "3" ,"version" => "2.2", "operating_system" => "debian"}]
    @database_objects
  end

  def teardown
    @database_objects = nil
  end

  should "return an empty list" do
    empty_list = []
    assert_equal  [],DatabaseHelper.list_database(empty_list)
  end

  should "return a list with current database objects" do
    list_compare = []
    assert_equal  list_compare.class, DatabaseHelper.list_database(@database_objects).class
  end

  should "have same information from the list passed as parameter" do
    list_compare = DatabaseHelper.list_database(@database_objects)
    assert_equal @database_objects.first[:database_description_id], list_compare.first.database_description_id
  end

  should "return a list with the same size of the parameter" do
    list_compare = DatabaseHelper.list_database(@database_objects)
    assert_equal @database_objects.count, list_compare.count
  end

  should "return false if list_database are empty or null" do
    list_compare = []
    assert_equal false,DatabaseHelper.valid_list_database?(list_compare)
  end

 should "return a html text with operating system equals to linux" do
      databases = []

      database_description = DatabaseDescription.new
      database_description.name = "teste"

      software_database = SoftwareDatabase.new
      software_database.version = 2
      software_database.operating_system = "linux"
      software_database.database_description = database_description

      databases << software_database

      assert_not_nil DatabaseHelper.database_as_tables(databases).first.call.index("linux")
    end
  end
