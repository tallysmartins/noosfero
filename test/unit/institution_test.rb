require File.dirname(__FILE__) + '/../../../../test/test_helper'

class InstitutionTest < ActiveSupport::TestCase

  should "save public institutions without name" do
    institution = Institution::new
    assert !institution.save
    assert institution.errors.full_messages.include? "Name can't be blank"
  end

  should "not save if institution has invalid type" do
    institution = Institution::new :name => "teste", :type => "Other type"
    assert !institution.save
    assert institution.errors.full_messages.include? "Type invalid, only public and private institutions are allowed."
  end
end