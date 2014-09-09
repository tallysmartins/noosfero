require File.dirname(__FILE__) + '/../../../../test/test_helper'

class DatabaseValidationTest < ActiveSupport::TestCase

  def setup
   @database_desc = DatabaseDescription.create(:name => "ABC")
   @database = SoftwareDatabase.new
   @database.database_description = @database_desc
   @database.version = "MYSQL"
   @database.operating_system = "debian"
   @database
  end

  def teardown
    @database = nil
  end

  should "Save database if all fields are filled" do
    assert_equal true, @database.save
  end

  should "Don't save database if database_description database_description is empty" do
    @database.database_description = nil
    assert_equal true, !@database.save
  end

  should "Don't save database if operating system are empty" do
    @database.operating_system = " "
    assert_equal true, !@database.save
  end

  should "Don't save database if version are empty" do
    @database.version = " "
    assert_equal true, !@database.save
  end

  should "Don't save database if version is too long" do
    @database.version = "A too long version to be a valid version for database"
    assert !@database.save
  end

  should "Don't save database if operating system is too long" do
    @database.operating_system = "A too long operating system to be a valid operating system for library"
    assert !@database.save
  end
end
