class InstitutionsBlock < CommunitiesBlock

  def self.description
    _('Institutions')
  end

  def profile_count
    profile_list.count
  end

  def default_title
    n_('{#} institution', '{#} institutions', profile_count)
  end

  def help
    _('This block displays the institutions in which the user is a member.')
  end

  def footer
    owner = self.owner
    case owner
    when Profile
      lambda do |context|
        link_to s_('institutions|View all'), :profile => owner.identifier, :controller => 'profile', :action => 'communities', :type => 'Institution'
      end
    when Environment
      lambda do |context|
        link_to s_('institutions|View all'), :controller => 'search', :action => 'communities', :type => 'Institution'
      end
    else
      ''
    end
  end

  def profile_list
    result = nil
    visible_profiles = profiles.visible.includes([:image,:domains,:preferred_domain,:environment])
    if !prioritize_profiles_with_image
      result = visible_profiles.all(:limit => get_limit, :order => 'profiles.updated_at DESC').sort_by{ rand }
    elsif profiles.visible.with_image.count >= get_limit
      result = visible_profiles.with_image.all(:limit => get_limit * 5, :order => 'profiles.updated_at DESC').sort_by{ rand }
    else
      result = visible_profiles.with_image.sort_by{ rand } + visible_profiles.without_image.all(:limit => get_limit * 5, :order => 'profiles.updated_at DESC').sort_by{ rand }
    end

    communities_with_institution_list = []

    result.each do |r|
      if r.class == Community and r.institution?
        communities_with_institution_list << r
      end
    end

    result = communities_with_institution_list

    result.slice(0..get_limit-1)
  end

  def profiles
    owner.communities
  end

end
