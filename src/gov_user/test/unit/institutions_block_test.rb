require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class InstitutionsBlockTest < ActiveSupport::TestCase
  include PluginTestHelper
  should 'inherit from Block' do
    assert_kind_of Block, InstitutionsBlock.new
  end

  should 'declare its default title' do
    InstitutionsBlock.any_instance.stubs(:profile_count).returns(0)
    assert_not_equal Block.new.default_title, InstitutionsBlock.new.default_title
  end

  should 'describe itself' do
    assert_not_equal Block.description, InstitutionsBlock.description
  end

  should 'give empty footer on unsupported owner type' do
    block = InstitutionsBlock.new
    block.expects(:owner).returns(1)
    assert_equal '', block.footer
  end

  should 'list institutions' do
    user = create_person("Jose_Augusto",
            "jose_augusto@email.com",
            "aaaaaaa",
            "aaaaaaa",
            'jose@secondary.com',
            "DF",
            "Gama"
          )

    institution  = create_private_institution(
                    "inst name",
                    "IN",
                    "country",
                    "state",
                    "city",
                    "00.111.222/3333-44"
                   )
    institution.community.add_member(user)

    block = InstitutionsBlock.new
    block.expects(:owner).at_least_once.returns(user)

    assert_equivalent [institution.community], block.profiles
  end

end
