require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareDatabaseTest < ActiveSupport::TestCase
  DatabaseDescription.create!(name: "MySQL")

  def setup
    @software_database = SoftwareDatabase.new(:version => "1.0", :operating_system => "Debian")
    @software_database.database_description_id = 1
  end

  def teardown
    DatabaseDescription.destroy_all
    SoftwareDatabase.destroy_all
  end

  should "save if all informations of @software_database are filled" do
    assert @software_database.save, "Database should have been saved" 
  end
  
  should "not save if database description id is empty" do
    @software_database.database_description_id = nil
    assert !@software_database.save, "Database description must be filled" 
  end

  should "not save if version is empty" do
    @software_database.version = nil
    assert !@software_database.save, "Version must be filled" 
  end

  should "not save if version has more than 20 characters" do
    @software_database.version = "a"*21
    assert !@software_database.save, "Version must have until 20 characters" 
  end

  should "not save if operating system is empty" do
    @software_database.operating_system = nil
    assert !@software_database.save, "Operating system must be filled" 
  end
  
  should "not save if operating system has more than 20 characters" do
    @software_database.operating_system = "a"*21
    assert !@software_database.save, "Operating system must have until 20 characters" 
  end
end
