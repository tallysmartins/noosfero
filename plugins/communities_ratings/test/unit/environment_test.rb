require 'test_helper'

class EnvironmentTest < ActiveSupport::TestCase
  test "Communities ratings default rating validation" do
    environment = Environment.new :communities_ratings_default_rating => 0
    environment.valid?

    assert_equal "must be greater than or equal to 1", environment.errors[:communities_ratings_default_rating].first

    environment.communities_ratings_default_rating = 6
    environment.valid?

    assert_equal "must be less than or equal to 5", environment.errors[:communities_ratings_default_rating].first
  end

  test "Communities ratings cooldown validation" do
    environment = Environment.new :communities_ratings_cooldown => -1
    environment.valid?

    assert_equal "must be greater than or equal to 0", environment.errors[:communities_ratings_cooldown].first
  end

  test "communities ratings per page validation" do
    environment = Environment.new :communities_ratings_per_page => 4
    environment.valid?

    assert_equal "must be greater than or equal to 5", environment.errors[:communities_ratings_per_page].first

    environment.communities_ratings_per_page = 21
    environment.valid?

    assert_equal "must be less than or equal to 20", environment.errors[:communities_ratings_per_page].first
  end
end
