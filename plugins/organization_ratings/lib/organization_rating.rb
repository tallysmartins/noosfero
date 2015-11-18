class OrganizationRating < ActiveRecord::Base
  belongs_to :person
  belongs_to :organization
  belongs_to :comment

  attr_accessible :value, :person, :organization, :comment, :comment_rejected

  validates :value,
            :presence => true, :inclusion => {
              in: 1..5, message: _("must be between 1 and 5")
            }

  validates :organization_id, :person_id,
            :presence => true

  def comment_rejected?
    return comment_rejected
  end

  def self.average_rating organization_id
    average = OrganizationRating.where(organization_id: organization_id).average(:value)

    if average
      (average - average.truncate) >= 0.5 ? average.ceil : average.floor
    end
  end

end
