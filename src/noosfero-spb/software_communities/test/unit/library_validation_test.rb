require 'test_helper'

class LibraryValidationTest < ActiveSupport::TestCase

  def setup
    @library = SoftwareCommunitiesPlugin::Library.new
    @library.name = "name"
    @library.version = "version"
    @library.license = "license"
  end

  should "Save Libray if all fields are filled" do
    assert @library.save
  end

  should "Don't save Library of name are not filed" do
    @library.name = ""
    assert !@library.save
  end

  should "Don't save Library of version are not filed" do
    @library.version = ""
    assert !@library.save
  end

  should "Don't save Library of license are not filed" do
    @library.license = ""
    assert !@library.save
  end

  should "Don't save Library if name is too long" do
    @library.name = "A too long name to be a valid name for library"
    assert !@library.save
  end

  should "Don't save Library if version is too long" do
    @library.version = "A too long version to be a valid version for library"
    assert !@library.save
  end

  should "Don't save Library if license is too long" do
    @library.license = "A too long license to be a valid license for library"
    assert !@library.save
  end
end
