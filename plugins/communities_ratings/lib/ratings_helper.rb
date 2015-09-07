module RatingsHelper

  def env_community_ratings_config
    CommunityRatingsConfig.instance
  end

  def get_ratings (profile_id)
    if env_community_ratings_config.order.downcase == ("best")
      ratings = CommunityRating.where(community_id: profile_id).order("value DESC")
    else
      ratings = CommunityRating.where(community_id: profile_id).order("created_at DESC")
    end
  end
end