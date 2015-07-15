require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class CommentTest < ActiveSupport::TestCase
  include PluginTestHelper

  should "validate institution if there an institution_id" do
    private_institution = build_private_institution "huehue", "hue", "11.222.333/4444-55"

    assert_equal true, private_institution.save

    comment = Comment.new :institution_id => 123456, :body => "simple body"
    comment.valid?

    assert_equal true, comment.errors[:institution].include?("not found")

    comment.institution = private_institution
    comment.valid?

    assert_equal false, comment.errors[:institution].include?("not found")
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

