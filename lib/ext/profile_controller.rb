require_dependency 'profile_controller'

class ProfileController

  def communities
    type = []
    params[:type].downcase! unless params[:type].nil?

    if params[:type] == "software"
      type = profile.softwares
    elsif params[:type] == "institution"
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

  def members
    if is_cache_expired?(profile.members_cache_key(params))
      all_members = if params[:sort] and params[:sort] == "desc"
        profile.members.order("name desc")
      else
        profile.members.order("name asc")
      end
      @profile_admins = profile.admins
      @profile_members = all_members - @profile_admins
      @profile_members = @profile_members.paginate(:per_page => members_per_page, :page => params[:npage], :total_entries => @profile_members.size)
      @profile_admins = @profile_admins.paginate(:per_page => members_per_page, :page => params[:npage], :total_entries => @profile_admins.size)
      @total_members = all_members.size
      @profile_members_url = url_for(:controller => "profile", :action => "members")
    end
  end

end
