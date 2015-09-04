class CommunitiesRatingsPluginProfileController < ProfileController
  include RatingsHelper

  def new_rating
    @rating_available = user_can_rate_now?
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
        session[:notice] = _("You can not vote on this community")
      end
    end
  end

  private

  def user_can_rate_now?
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
    rating = CommunityRating.new(params[:community_rating])
    rating.person = current_user.person
    rating.community = profile
    rating.value = params[:community_rating_value] if params[:community_rating_value]

    if rating.save
      create_rating_comment(rating)
      session[:notice] = _("#{profile.name} successfully rated!")
    else
      session[:notice] = _("Sorry, there were problems rating this profile.")
    end

    redirect_to :controller => 'profile',  :action => 'index'
  end

  def create_rating_comment(rating)
    if params[:comments]
        comment_task = CreateCommunityRatingComment.create!(
          params[:comments].merge(
            :requestor => rating.person,
            :community_rating_id => rating.id,
            :organization => rating.community
          )
        )
        comment_task.finish if can_perform?(params)
    end
  end

  def can_perform? (params)
     (params[:comments][:body].blank? ||
      params[:comments][:body].empty? ||
      !environment.communities_ratings_are_moderated)
  end

  def permission
    :manage_memberships
  end
end
