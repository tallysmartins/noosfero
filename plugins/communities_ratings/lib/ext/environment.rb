require_dependency 'environment'

Environment.class_eval do
  attr_accessible :communities_ratings_cooldown, :communities_ratings_default_rating, :communities_ratings_order, :communities_ratings_per_page, :communities_ratings_vote_once, :communities_ratings_are_moderated

  COMMUNITIES_RATINGS_ORDER_OPTIONS = ["Most Recent", "Best Ratings"]
  COMMUNITIES_RATINGS_MINIMUM_RATING = 1
  COMMUNITIES_RATINGS_MAX_COOLDOWN = 1000

  validates :communities_ratings_default_rating,
            :presence => true, :numericality => {
              greater_than_or_equal_to: COMMUNITIES_RATINGS_MINIMUM_RATING,
              less_than_or_equal_to: 5
            }

  validates :communities_ratings_cooldown,
            :presence => true, :numericality => {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: COMMUNITIES_RATINGS_MAX_COOLDOWN
            }

  validates :communities_ratings_per_page,
            :presence => true, :numericality => {
              :greater_than_or_equal_to => 5,
              :less_than_or_equal_to  => 20
            }

  def self.communities_ratings_min_rating
    COMMUNITIES_RATINGS_MINIMUM_RATING
  end

  def self.communities_ratings_order_options
    COMMUNITIES_RATINGS_ORDER_OPTIONS
  end
end
