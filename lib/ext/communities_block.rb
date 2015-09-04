require_dependency 'communities_block'

class CommunitiesBlock

  def profile_list
    result = get_visible_profiles
    result.slice(0..get_limit-1)
  end

  def profile_count
    profile_list.count
  end

  private

  def get_visible_profiles
    visible_profiles = profiles.visible.includes(
      [:image,:domains,:preferred_domain,:environment]
    )

    delete_communities = []
    valid_communities_string = Community.get_valid_communities_string
    Community.all.each{|community| delete_communities << community.id unless eval(valid_communities_string)}

    visible_profiles = visible_profiles.where(["profiles.id NOT IN (?)", delete_communities])

    if !prioritize_profiles_with_image
      return visible_profiles.all(
        :limit => get_limit,
        :order => 'profiles.updated_at DESC'
      ).sort_by {rand}
    elsif profiles.visible.with_image.count >= get_limit
      return visible_profiles.with_image.all(
        :limit => get_limit * 5,
        :order => 'profiles.updated_at DESC'
      ).sort_by {rand}
    else
      visible_profiles = visible_profiles.with_image.sort_by {rand} +
        visible_profiles.without_image.all(
          :limit => get_limit * 5, :order => 'profiles.updated_at DESC'
        ).sort_by {rand}
      return visible_profiles
    end
  end
end
