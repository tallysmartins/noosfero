require File.dirname(__FILE__) + '/../../../../test/test_helper'

class DatabaseHelperTest < ActiveSupport::TestCase

  include DatabaseHelper

  def setup
    dd1 = DatabaseDescription.create(:name => "Oracle")
    dd2 = DatabaseDescription.create!(:name => "MySQL")

    @database_objects = [
      {:database_description_id => dd1.id.to_s ,:version => "2.0"},
      {:database_description_id => dd2.id.to_s ,:version => "2.1"}
    ]
  end

  def teardown
    @database_objects = nil
    SoftwareDatabase.destroy_all
    DatabaseDescription.destroy_all
  end

  should "return an empty list" do
    empty_list = []
    assert_equal [], DatabaseHelper.list_database(empty_list)
  end

  should "return a list with current database objects" do
    list_compare = []
    db_tables = DatabaseHelper.list_database(@database_objects)
    assert_equal list_compare.class, db_tables.class
  end

  should "have same information from the list passed as parameter" do
    list_compare = DatabaseHelper.list_database(@database_objects)
    db_objects_id = @database_objects.first[:database_description_id]
    assert_equal db_objects_id.to_i, list_compare.first.database_description_id
  end

  should "return a list with the same size of the parameter" do
    list_compare = DatabaseHelper.list_database(@database_objects)
    assert_equal @database_objects.count, list_compare.count
  end

  should "return false if list_database are empty or null" do
    list_compare = []
    assert_equal false,DatabaseHelper.valid_list_database?(list_compare)
  end

  should "remove invalid tables from the list" do
    @database_objects.push({
      :database_description_id => "I'm not a valid id",
      :version => "2.5"
    })

    database_objects_length = @database_objects.count
    list_compare = DatabaseHelper.list_database(@database_objects)
    assert_equal list_compare.count, database_objects_length-1
  end
end
