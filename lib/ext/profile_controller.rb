require_dependency 'profile_controller'

class ProfileController

  before_filter :hit_view_page

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

  def user_is_a_bot?
    user_agent= request.env["HTTP_USER_AGENT"]
    user_agent.blank? ||
    user_agent.match(/bot/) ||
    user_agent.match(/spider/) ||
    user_agent.match(/crawler/) ||
    user_agent.match(/\(.*https?:\/\/.*\)/)
  end

  def already_visited?(element)
    user_id = if user.nil? then -1 else current_user.id end
    user_id = "#{user_id}_#{element.id}_#{element.class}"

    if cookies.signed[:visited] == user_id
      return true
    else
      cookies.permanent.signed[:visited] = user_id
      return false
    end
  end

  def hit_view_page
    if profile
      community = profile
      community.hit unless user_is_a_bot?  ||
                           already_visited?(community) ||
                           community.class != Community
    end
  end
end
