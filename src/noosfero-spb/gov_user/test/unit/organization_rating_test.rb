require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../helpers/plugin_test_helper'

class OrganizationRatingTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.save
  end

  should "not validate organization rating if the institution is not saved" do
    person = fast_create(Person)
    community = fast_create(Community)

    private_institution = build_private_institution "Some Institution", "Some Inst Incorporated", "11.222.333/4444-55"
    community_rating = OrganizationRating.new(:person => person, :value => 3, :organization => community, :institution => private_institution)

    assert_equal false, community_rating.valid?
    assert_equal true, community_rating.errors.messages.keys.include?(:institution)
  end

  should "validate organization rating if the institution is saved" do
    person = fast_create(Person)
    community = fast_create(Community)

    private_institution = build_private_institution "Some Institution", "Some Inst Incorporated", "11.222.333/4444-55"
    community_rating = OrganizationRating.new(:person => person, :value => 3, :organization => community, :institution => private_institution)
    private_institution.save

    assert_equal true, community_rating.valid?
    assert_equal false, community_rating.errors.messages.keys.include?(:institution)
  end

  should "not create organization rating with saved value and no institution" do
    person = fast_create(Person)
    community = fast_create(Community)

    community_rating = OrganizationRating.new(:person => person, :value => 3, :organization => community, :institution => nil)
    community_rating.saved_value = "2000"

    assert_equal false, community_rating.save
    assert_equal true, community_rating.errors.messages.keys.include?(:institution)
  end

  should "not create organization rating with benefited people value and no institution" do
    person = fast_create(Person)
    community = fast_create(Community)

    community_rating = OrganizationRating.new(:person => person, :value => 3, :organization => community, :institution => nil)
    community_rating.people_benefited = "100"

    assert_equal false, community_rating.save
    assert_equal true, community_rating.errors.messages.keys.include?(:institution)
  end

  private

  def build_private_institution name, corporate_name, cnpj, country="AR"
    community = Community.new :name => name
    community.country = country

    institution = PrivateInstitution.new :name=> name
    institution.corporate_name = corporate_name
    institution.cnpj = cnpj
    institution.community = community

    institution
  end
end

