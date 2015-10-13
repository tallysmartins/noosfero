require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class CategoriesSoftwareBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  should 'inherit from Block' do
    assert_kind_of Block, CategoriesSoftwareBlock.new
  end

  should 'declare its default title' do
    CategoriesSoftwareBlock.any_instance.stubs(:profile_count).returns(0)
    assert_equal Block.new.default_title, CategoriesSoftwareBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, CategoriesSoftwareBlock.description
  end

end
