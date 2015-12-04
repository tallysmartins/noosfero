require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class CategoriesAndTagsBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  should 'inherit from Block' do
    assert_kind_of Block, CategoriesAndTagsBlock.new
  end

  should 'declare its default title' do
    CategoriesAndTagsBlock.any_instance.stubs(:profile_count).returns(0)
    assert_equal Block.new.default_title, CategoriesAndTagsBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, CategoriesAndTagsBlock.description
  end

end
