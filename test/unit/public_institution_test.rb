require File.dirname(__FILE__) + '/../../../../test/test_helper'

class PublicInstitutionTest < ActiveSupport::TestCase
  def setup
    govPower = GovernmentalPower.create(:name=>"Some Gov Power")
    govSphere = GovernmentalSphere.create(:name=>"Some Gov Sphere")
    juriNature = JuridicalNature.create(:name => "Some jurid nature")
    community = Community.create(:name => "Simple Public Institution")

    @institution = PublicInstitution::new :name=>"Simple Public Institution", :acronym=>"SPI",
      :governmental_power=>govPower, :governmental_sphere=>govSphere, :juridical_nature => juriNature

    @institution.community = community
    @institution.community.country = "BR"
    @institution.community.state = "DF"
    @institution.community.city = "Gama"
  end

  should "save without a cnpj" do
    @institution.cnpj = nil
    assert @institution.save 
  end

  should "save institution without an acronym" do
    @institution.acronym = nil
    assert @institution.save
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

  should "not save institution without juridical nature" do
    @institution.juridical_nature = nil

    assert !@institution.save
    assert @institution.errors.full_messages.include? "Juridical nature can't be blank"
  end
end
