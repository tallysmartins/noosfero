require_dependency "create_community_rating_comment"

CreateCommunityRatingComment.class_eval do
  attr_accessible :institution_id
end

