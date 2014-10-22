require_dependency 'communities_block'

class CommunitiesBlock

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

    list_without_software_and_institution = []

    visible_profiles.each do |p|
			if p.class == Community and !p.software? and !p.institution?
				list_without_software_and_institution << p
			end
    end

    result = list_without_software_and_institution

    result.slice(0..get_limit-1)
  end

end