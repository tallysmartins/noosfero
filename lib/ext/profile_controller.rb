require_dependency 'profile_controller'

class ProfileController

  def communities
    type = []
    if params[:type] == "Software"
      type = profile.softwares
    elsif params[:type] == "Institution"
      type = profile.institutions
    else
      profile.communities.select do |community|
        type << community unless community.software? || community.institution?
      end
    end

    if is_cache_expired?(profile.communities_cache_key(params))
      @communities = type.paginate(:per_page => per_page, :page => params[:npage], :total_entries => type.count)
    end
  end
end
