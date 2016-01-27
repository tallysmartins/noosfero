require 'test_helper'

class SoftwareDatabaseTest < ActiveSupport::TestCase
  def setup
    DatabaseDescription.create!(name: "PostgreSQL")
    @software_database = SoftwareDatabase.new(
                          :version => "1.0"
                        )
    @software_database.database_description_id = 1
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
end
