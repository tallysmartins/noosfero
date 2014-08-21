require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PrivateInstitutionTest < ActiveSupport::TestCase
  def setup
    community = Community.create(:name => "Simple Private Institution")
    @institution = PrivateInstitution::new :name=>"Simple Private Institution",
      :cnpj=>"00.000.000/0001-00"
    @institution.community = community
    @institution.community.country = "BR"
    @institution.community.state = "DF"
    @institution.community.city = "Gama"
  end

  should "not save without a cnpj" do
    @institution.cnpj = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Cnpj can't be blank"
  end

  should "not save with a repeated cnpj" do
    assert @institution.save

    sec_institution = PrivateInstitution::new :name=>"Another Private Institution",
      :cnpj=>"00.000.000/0001-00"
    sec_institution.community = Community.create(:name => "Another Private Institution")

    assert !sec_institution.save
    assert sec_institution.errors.full_messages.include? "Cnpj has already been taken"
  end

  should "save without fantasy name" do
    @institution.acronym = nil
    @institution.community.save

    assert @institution.save
  end
end
