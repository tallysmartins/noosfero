require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class CommunityRatingTest < ActiveSupport::TestCase
  include PluginTestHelper

  should "validate institution if there an institution_id" do
    private_institution = build_private_institution "huehue", "hue", "11.222.333/4444-55"

    assert_equal true, private_institution.save

    rating = CommunityRating.new :institution_id => 123456
    rating.valid?

    assert_equal true, rating.errors[:institution].include?("not found")

    rating.institution = private_institution
    rating.valid?

    assert_equal false, rating.errors[:institution].include?("not found")
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

