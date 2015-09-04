class CommunityRating < ActiveRecord::Base
  belongs_to :person
  belongs_to :community
  belongs_to :comment

  attr_accessible :value, :person, :community, :comment

  validates :value,
            :presence => true, :inclusion => {
              in: 1..5, message: _("must be between 1 and 5")
            }

  validates :community_id, :person_id,
            :presence => true


  def self.average_rating community_id
    average = CommunityRating.where(community_id: community_id).average(:value)

    if average
      (average - average.truncate) >= 0.5 ? average.ceil : average.floor
    else
      nil
    end
  end

end
