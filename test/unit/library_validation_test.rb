require File.dirname(__FILE__) + '/../../../../test/test_helper'

class LibraryValidationTest < ActiveSupport::TestCase

  def setup
    @library = Library.new
    @library.name = "name"
    @library.version = "version"
    @library.license = "license"
  end

  def teardown
    @Libray = nil
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
end
