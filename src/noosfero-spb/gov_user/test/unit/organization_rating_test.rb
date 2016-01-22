require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../helpers/plugin_test_helper'

class OrganizationRatingTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.save
  end

  should "validate institution if there is an institution_id" do
    person = fast_create(Person)
    community = fast_create(Community)
    private_institution = build_private_institution "huehue", "hue", "11.222.333/4444-55"

    community_rating = OrganizationRating.new(:person => person, :value => 3, :organization => community, :institution => private_institution)

    assert_equal false, community_rating.valid?

    private_institution.save
    community_rating.institution = private_institution

    assert_equal true, community_rating.valid?
    assert_equal false, community_rating.errors[:institution].include?("institution not found")
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

