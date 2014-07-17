require File.dirname(__FILE__) + '/../../../../test/test_helper'

class InstitutionHelperTest < ActiveSupport::TestCase

  should "populate public institutions with data from SIORG" do
    Institution.destroy_all

    InstitutionHelper.mass_update

    assert Institution.count != 0
  end

  should "receive json data from SIORG"  do
    data = InstitutionHelper.get_json(2, 1)

    assert data["unidades"].count != 0
  end
end
