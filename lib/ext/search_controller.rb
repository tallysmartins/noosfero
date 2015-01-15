require_dependency 'search_controller'

class SearchController

  def communities
    results = filter_communities_list do |community|
      !community.software? and !community.institution?
    end
    results = results.paginate(:per_page => 24, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
  end

  def institutions
    @titles[:institutions] = _("Institution Catalog")
    @category_filters = []
    results = filter_communities_list{|community| community.institution?}
    results = results.paginate(:per_page => 24, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
  end


  def software_infos
    @titles[:software_infos] = _("Software Catalog")
    @category_filters = []
    @categories = Category.all

    results = filter_software_infos_list
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
      if profile.class == Community && !profile.is_template? && yield(profile)
          communities_list << profile
      end
    end

    communities_list
  end

  def filter_software_infos_list
    filtered_communities_list = SoftwareInfo.like_search(params[:query])

    if not params[:categories].blank?
      @category_filters = params[:categories].select {|c| c.to_i != 0 }
      
      filtered_communities_list.select! do |software|
        !(software.community.category_ids & @category_filters).blank?
      end
    end

    filtered_communities_list
  end
end
