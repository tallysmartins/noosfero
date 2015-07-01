require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'
require 'ratings_helper'

class RatingsHelperTest < ActiveSupport::TestCase
  include RatingsHelper

  def setup

    @environment = Environment.default
    @environment.enabled_plugins = ['CommunitiesRatingsPlugin']
    @environment.save
    @person = create_user('testuser').person
    @community = Community.create(:name => "TestCommunity")
    @community_ratings_config = CommunityRatingsConfig.instance
  end

  should "get the ratings of a community ordered by most recent ratings" do
    ratings_array = []

    first_rating = CommunityRating.new
    first_rating.community = @community
    first_rating.person = @person
    first_rating.value = 3
    first_rating.save

    most_recent_rating = CommunityRating.new
    most_recent_rating.community = @community
    most_recent_rating.person = @person
    most_recent_rating.value = 5
    sleep 2
    most_recent_rating.save

    ratings_array << most_recent_rating
    ratings_array << first_rating

    assert_equal @community_ratings_config.order, "recent"
    assert_equal ratings_array, get_ratings(@community.id)
  end

  should "get the ratings of a community ordered by best ratings" do
    ratings_array = []
    @community_ratings_config = "best"
    @environment.save

    first_rating = CommunityRating.new
    first_rating.community = @community
    first_rating.person = @person
    first_rating.value = 3
    first_rating.save

    second_rating = CommunityRating.new
    second_rating.community = @community
    second_rating.person = @person
    second_rating.value = 5
    sleep 2
    second_rating.save

    ratings_array << second_rating
    ratings_array << first_rating

    assert_equal ratings_array, get_ratings(@community.id)
  end
end
