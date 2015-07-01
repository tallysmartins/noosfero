require_dependency "comment"

Comment.class_eval do
  alias :community :source
  alias :community= :source=

  belongs_to :community_rating
end
