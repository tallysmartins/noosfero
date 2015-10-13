require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareTabDataBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @software_info = create_software_info("A new Software")
    @software_info.save!

    @soft_community = @software_info.community

    @soft_community.blogs << Blog.new(:name=>"First blog")
    @soft_community.blogs << Blog.new(:name=>"Second blog")
    @soft_community.save!

    SoftwareTabDataBlock.any_instance.stubs(:owner).returns(@soft_community)
  end

  should "get its owner blogs" do
    assert_equal @soft_community.blogs, SoftwareTabDataBlock.new.blogs
  end

  should "actual_blog get the first blog if it is not defined" do
    assert_equal @soft_community.blogs.first, SoftwareTabDataBlock.new.actual_blog
  end

  should "actual_blog get the defined community blog" do
    last_blog = @soft_community.blogs.last
    soft_tab_data = create_software_tab_data_block(last_blog)

    assert_equal last_blog, soft_tab_data.actual_blog
  end

  should "get the actual_blog posts" do
    last_blog = @soft_community.blogs.last
    soft_tab_data = create_software_tab_data_block(last_blog)
    craete_sample_posts(last_blog, 2)

    assert_equal last_blog.posts.first.id, soft_tab_data.posts.first.id
    assert_equal last_blog.posts.last.id, soft_tab_data.posts.last.id
  end

  should "limit the number of posts" do
    last_blog = @soft_community.blogs.last
    soft_tab_data = create_software_tab_data_block(last_blog)
    craete_sample_posts(last_blog, 6)

    assert_equal SoftwareTabDataBlock::TOTAL_POSTS_DYSPLAYED, soft_tab_data.posts.count
  end

  private

  def create_software_tab_data_block blog
    soft_tab_data = SoftwareTabDataBlock.new
    soft_tab_data.displayed_blog = blog.id
    soft_tab_data
  end

  def craete_sample_posts blog, quantity=1
    quantity.times do |number|
      TinyMceArticle.create! :name=>"Simple post #{number}", :body=>"Simple post #{number}",
                             :parent=> blog, :profile=>@soft_community
    end
  end
end
