class AverageRatingBlock < Block
  include RatingsHelper

  def self.description
    _('Organization Average Rating')
  end

  def help
    _('This block displays the organization average rating.')
  end

  def content(args = {})
    profile_identifier = self.owner.identifier
    statistics = OrganizationRating.statistics_for_profile self.owner
    block = self

    proc do
      render(
        :file => 'blocks/display_organization_average_rating',
        :locals => {
          :profile_identifier => profile_identifier,
          :average_rating => statistics[:average],
          :block => block
        }
      )
    end
  end

  def cacheable?
    false
  end
end
