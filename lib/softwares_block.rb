class SoftwaresBlock < CommunitiesBlock

  settings_items :software_type, :default => "All"
  attr_accessible :accessor_id, :accessor_type, :role_id, :resource_id, :resource_type, :software_type

  def self.description
    _('Softwares')
  end

  def default_title
    if self.software_type == "Generic"
      return n_('{#} generic software', '{#} generic softwares', profile_count)
    elsif self.software_type == "Public"
      return n_('{#} public software', '{#} public softwares', profile_count)
    else
      return n_('{#} software', '{#} softwares', profile_count)
    end
  end

  def help
    _('This block displays the softwares in which the user is a member.')
  end

  def footer
    self.software_type ||= "All"
    owner = self.owner
    case owner
    when Profile
      lambda do |context|
        link_to s_('softwares|View all'), :profile => owner.identifier, :controller => 'profile', :action => 'communities', :type => 'Software'
      end
    when Environment
      lambda do |context|
        link_to s_('softwares|View all'), :controller => 'search', :action => 'communities', :type => 'Software'
      end
    else
      ''
    end
  end

  def profile_count
    profile_list.count
  end

  def profiles
    owner.communities
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

    list_with_software = []

    result.each do |profile|
			if profile.class == Community and profile.software?
        if self.software_type == "Public"
          list_with_software << profile if profile.software_info.public_software?
        elsif self.software_type == "Generic"
          list_with_software << profile if !profile.software_info.public_software?
        else
          list_with_software << profile
        end
			end
    end

    result = list_with_software

    result.slice(0..get_limit-1)
  end
end
