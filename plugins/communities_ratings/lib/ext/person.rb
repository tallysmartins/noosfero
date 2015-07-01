require_dependency 'person'

Person.class_eval do
  has_many :community_ratings
end
