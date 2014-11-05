require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'

class PrivateInstitutionTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    @institution = create_private_institution "Simple Private Institution", "SPI", "BR", "DF", "Gama", "00.000.000/0001-00"
  end

  should "not save without a cnpj" do
    @institution.cnpj = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Cnpj can't be blank"
  end

  should "not save with a repeated cnpj" do
    assert @institution.save
    sec_institution = create_private_institution "Another Private Institution", "API", "BR", "DF", "Gama", "00.000.000/0001-00"

    assert sec_institution.errors.full_messages.include? "Cnpj has already been taken"
  end

  should "save without fantasy name" do
    @institution.acronym = nil
    @institution.community.save

    assert @institution.save
  end
end
