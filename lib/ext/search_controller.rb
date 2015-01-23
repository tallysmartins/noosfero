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
    prepare_software_search_page
    results = filter_software_infos_list
    results = results.paginate(:per_page => 24, :page => params[:page])
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
    filtered_software_list = SoftwareInfo.like_search(params[:query])

    category_ids = []
    unless params[:selected_categories].blank?
      category_ids = params[:selected_categories]
    end
    category_ids = category_ids.map(&:to_i)

    unless category_ids.empty?
      filtered_software_list.select! do |software|
        result_ids = (software.community.category_ids & category_ids).sort
        result_ids == category_ids.sort
      end
    end

    filtered_community_list = []
    filtered_software_list.each do |software|
      filtered_community_list << software.community
    end

    filtered_community_list
  end

  protected

  def prepare_software_search_page
    @titles[:software_infos] = _("Public Software Catalog")
    @category_filters = []
    @categories = Category.software_categories
    @selected_categories = params[:selected_categories]
    @selected_categories ||= []
    @selected_categories = @selected_categories.map(&:to_i)

    @message_selected_options = ""
    unless @selected_categories.empty?
      @message_selected_options = _("Selected options: ")

      categories = Category.find(@selected_categories)
      @message_selected_options += categories.collect { |category|
        "#{category.name}; "
      }.join()
    end

    @categories.sort!{|a, b| a.name <=> b.name}
    @categories_groupe_one = []
    @categories_groupe_two = []
    @categories.count.times do |i|
      if i % 2 == 0
        @categories_groupe_one << @categories[i]
      else
        @categories_groupe_two << @categories[i]
      end
    end
  end
end
