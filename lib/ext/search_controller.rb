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
    results = filter_communities_list{|community| community.institution?}
    results = results.paginate(:per_page => 24, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
  end


  def software_infos
    prepare_software_search_page
    results = filter_software_infos_list
    results = results.paginate(:per_page => @per_page, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results
    render :layout=>false if request.xhr?
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
    filtered_software_list = get_filtered_software_list
    filtered_community_list = get_communities_list(filtered_software_list)
    sort_communities_list filtered_community_list
  end

  protected

  def get_filter_category_ids
    category_ids = []
    unless params[:selected_categories].blank?
      category_ids = params[:selected_categories]
    end
    category_ids.map(&:to_i)
  end

  def get_filtered_software_list
    filtered_software_list = SoftwareInfo.like_search(params[:query])

    category_ids = get_filter_category_ids

    unless category_ids.empty?
      filtered_software_list.select! do |software|
        result_ids = (software.community.category_ids & category_ids).sort
        result_ids == category_ids.sort
      end
    end

    filtered_software_list
  end

  def get_communities_list software_list
    filtered_community_list = []
      software_list.each do |software|
       if @include_non_public || software.public_software?
         filtered_community_list << software.community
       end
    end
    filtered_community_list
  end

  def sort_communities_list communities_list
    communities_list.sort!{|a, b| a.name <=> b.name}
    if params[:sort] && params[:sort] == "desc"
      communities_list.reverse!
    end
    communities_list
  end

  def prepare_software_search_page
    prepare_software_infos_params
    prepare_software_infos_message
    prepare_software_infos_category_groups
  end

  def prepare_software_infos_params
    @titles[:software_infos] = _("Public Software Catalog")
    @selected_categories = params[:selected_categories]
    @selected_categories ||= []
    @selected_categories = @selected_categories.map(&:to_i)
    @include_non_public = params[:include_non_public] == "true"
    @per_page = prepare_per_page
  end

  def prepare_per_page
    return 15 if params[:software_display].nil?

    if params[:software_display] == "all"
      SoftwareInfo.count
    else
      params[:software_display].to_i
    end
  end

  def prepare_software_infos_message
    @message_selected_options = ""
    unless @selected_categories.empty?
      @message_selected_options = _("Selected options: ")

      categories = Category.find(@selected_categories)
      @message_selected_options += categories.collect { |category|
        "#{category.name}; "
      }.join()
    end
  end

  def prepare_software_infos_category_groups
    @categories = Category.software_categories.sort{|a, b| a.name <=> b.name}

    categories_sliced = @categories.each_slice(@categories.count/2)

    @categories_groupe_one = categories_sliced.next
    @categories_groupe_two = categories_sliced.next
  end
end
