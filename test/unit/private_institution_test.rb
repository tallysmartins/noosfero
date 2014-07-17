require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PrivateInstitutionTest < ActiveSupport::TestCase
  def setup
    @institution = PrivateInstitution::new :name=>"Simple Private Institution",
      :cnpj=>"00.000.000/0001-00"
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

    assert !sec_institution.save
    assert sec_institution.errors.full_messages.include? "Cnpj has already been taken"
  end
end