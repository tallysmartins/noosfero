require_dependency 'community'

Community.class_eval do
  has_many :community_ratings

  has_many :comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc'
end
