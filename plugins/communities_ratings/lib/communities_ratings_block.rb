class CommunitiesRatingsBlock < Block
  include RatingsHelper

  def self.description
    _('Community Ratings')
  end

  def help
    _('This block displays the community ratings.')
  end

  def content(args = {})
    block = self

    proc do
      render(
        :file => 'blocks/communities_ratings_block',
        :locals => {:block => block}
      )
    end
  end

  def limit_number_of_ratings
    count = self.owner.community_ratings.count
    count > 3 ? 3 : count
  end

  def cacheable?
    false
  end
end
