class CommunitiesRatingsPluginProfileController < ProfileController
  include RatingsHelper

  def new_rating
    @rating_available = can_rate_now?
    @users_ratings = get_ratings(profile.id)
    @users_ratings = @users_ratings.paginate(
                      :per_page => environment.communities_ratings_per_page,
                      :page => params[:npage]
                    )
    @default_rate =  environment.communities_ratings_default_rating
    @min_rate = Environment.communities_ratings_min_rating

    if request.post?
      if @rating_available
        create_new_rate
      else
        session[:notice] = _("You cant vote on this community")
      end
    end
  end

  private

  def can_rate_now?
    return false unless user

    ratings = CommunityRating.where(
      :community_id=>profile.id,
      :person_id=>user.id
    )

    return false if !ratings.empty? && environment.communities_ratings_vote_once

    if ratings.empty?
      true
    else
      elapsed_time_since_last_rating = Time.zone.now - ratings.last.created_at
      elapsed_time_since_last_rating > environment.communities_ratings_cooldown.hours
    end
  end

  def create_new_rate
    community_rating = CommunityRating.new(params[:community_rating])
    community_rating.person = current_user.person
    community_rating.community = profile
    community_rating.value = params[:community_rating_value] if params[:community_rating_value]

    if params[:comments] and (not params[:comments][:body].empty?)
      if !environment.communities_ratings_are_moderated
        comment = Comment.new(params[:comments])
        comment.author = community_rating.person
        comment.community = community_rating.community
        comment.save
   
        community_rating.comment = comment
      else
        create_comment = CreateCommunityRatingComment.create!(
          params[:comments].merge(
            :requestor => community_rating.person,
            :source => community_rating.community,
            :community_rating => community_rating,
            :organization => community_rating.community
          )
        )
      end
    end

    if community_rating.save
      session[:notice] = _("#{profile.name} successfully rated!")
      redirect_to :controller => 'profile',  :action => 'index'
    else
      session[:notice] = _("Sorry, there were problems rating this profile.")
    end
  end

  def permission
    :manage_memberships
  end
end
