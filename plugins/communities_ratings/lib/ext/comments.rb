require_dependency "comment"

Comment.class_eval do

  has_one :community_rating
end
