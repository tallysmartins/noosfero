require_dependency "comment"

Comment.class_eval do
  alias :community :source
  alias :community= :source=

  has_one :community_rating
end
