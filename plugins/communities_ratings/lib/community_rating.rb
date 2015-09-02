class CommunityRating < ActiveRecord::Base
  belongs_to :person
  belongs_to :community

  attr_accessible :value, :person, :community

  validates :value,
            :presence => true, :inclusion => {
              in: 1..5, message: _("must be between 1 and 5")
            }

  validates :community_id, :person_id,
            :presence => true

  has_one :comment

  def self.average_rating community_id
    average = CommunityRating.where(community_id: community_id).average(:value)

    if average
      (average - average.truncate) >= 0.5 ? average.ceil : average.floor
    else
      nil
    end
  end

  def get_task_status
    CreateCommunityRatingComment.where(community_rating_id: self).first.status
  end

  def get_comment_message
    if get_task_status == 1
      _("Comment waiting for approval")
    elsif get_task_status == 2
      _("Comment rejected")
    elsif get_task_status == 3 && self.comment.body
      self.comment.body
    else
      _("No comment")
    end
  end

end
