require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PublicInstitutionTest < ActiveSupport::TestCase
  def setup
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")

    @institution = PublicInstitution::new :name=>"Simple Public Institution", :acronym=>"SPI",
      :governmental_power=>govPower, :governmental_sphere=>govSphere
  end

  should "save without a cnpj" do
    @institution.cnpj = nil

    assert @institution.save
  end

  should "Not save institution without an acronym" do
    @institution.acronym = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Acronym can't be blank"
  end

  should "Not save institution without a governmental_power" do
    @institution.governmental_power = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Governmental power can't be blank"
  end

  should "Not save institution without a governmental_sphere" do
    @institution.governmental_sphere = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Governmental sphere can't be blank"
  end
end