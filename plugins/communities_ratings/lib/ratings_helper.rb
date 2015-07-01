module RatingsHelper

  def get_ratings (profile_id)
    if Environment.default.communities_ratings_order.downcase == ("best ratings")
      ratings = CommunityRating.where(community_id: profile_id).order("value DESC")
    else
      ratings = CommunityRating.where(community_id: profile_id).order("created_at DESC")
    end
  end
end