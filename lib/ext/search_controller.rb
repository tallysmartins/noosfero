require_dependency 'search_controller'

class SearchController

  def communities
    results = filter_communities_list{|community| !community.software? and !community.institution?}
    results = results.paginate(:per_page => 24, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
  end

  def software_infos
    @titles[:software_infos] = "Software Infos"

    results = filter_communities_list{|community| community.software?}
    results = results.paginate(:per_page => 24, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
  end

  def filter_communities_list
    unfiltered_list = visible_profiles(Community)
    unless params[:query].nil?
      unfiltered_list = unfiltered_list.select do |com|
        com.name.downcase =~ /#{params[:query].downcase}/
      end
    end
    communities_list = []
    unfiltered_list.each do |profile|
      if profile.class == Community and yield(profile)
        communities_list << profile
      end
    end
    communities_list
  end
end