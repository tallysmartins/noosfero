require File.dirname(__FILE__) + '/../../../../test/test_helper'

class InstitutionTest < ActiveSupport::TestCase

  def setup
    community = Community.create(:name => "Simple Public Institution")

    @institution = Institution::new :name=>"Simple Institution"

    @institution.community = community
    @institution.community.country = "BR"
    @institution.community.state = "DF"
    @institution.community.city = "Gama"
  end

  should "not save institutions without name" do
    @institution.name = nil
    assert !@institution.save
    assert @institution.errors.full_messages.include? "Name can't be blank"
  end

  should "not save if institution has invalid type" do
    @institution.type = "Other type"
    assert !@institution.save
    assert @institution.errors.full_messages.include? "Type invalid, only public and private institutions are allowed."
  end
  
  should "not save without country" do 
    @institution.community.country = nil
    assert !@institution.save, "Country can't be blank"
    assert @institution.errors.full_messages.include? "Country can't be blank"
  end

  should "not save without state" do 
    @institution.community.state = nil

    assert !@institution.save, "State can't be blank"
    assert @institution.errors.full_messages.include? "State can't be blank"
  end

  should "not save without city" do
    @institution.community.city = nil

    assert !@institution.save, "City can't be blank"
    assert @institution.errors.full_messages.include? "City can't be blank"
  end
end
