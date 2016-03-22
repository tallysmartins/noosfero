require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'
require 'test_helper'
require(
  File.dirname(__FILE__) +
  '/../../../../app/models/category'
)

class Category; def rescue_action(e) raise e end; end

class CategoyTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @category = Category.create(:name => "Category", :environment => @environment)
    @community_category = Category.create(:name => "Empty Category", :environment => @environment)

    @software1 = create_software_info "software 1"
    @software2 = create_software_info "software 2"
    @software1.community.add_category @category
    @software2.community.add_category @category
  end

  should "not return software infos for non software communities" do
    community = create_community "Community"
    community.add_category @community_category

    assert_empty @community_category.software_communities
  end

  should "return only software infos for category with community" do
    community = create_community "Community"
    community.add_category @category

    software_infos = @category.software_communities

    assert software_infos.include? @software1
    assert software_infos.include? @software2
    assert !software_infos.include?(community), "it should not return a community in the result"
  end

  should "return software_infos of all categories children" do
    sub_category = Category.create(:name => "Sub Category", :environment => @environment, :parent_id => @category.id)
    software3 = create_software_info "software 3"
    software3.community.add_category sub_category

    software_infos = @category.software_infos

    assert software_infos.include? @software1
    assert software_infos.include? @software2
    assert software_infos.include? software3
  end

end
