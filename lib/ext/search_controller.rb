require_dependency 'search_controller'

class SearchController

  def communities
    valid_communities_string = Community.get_valid_communities_string

    @scope = visible_profiles(Community)
    @scope.each{|community| @scope.delete(community) unless eval(valid_communities_string)}

    full_text_search
  end

  def software_infos
    prepare_software_search_page
    results = filter_software_infos_list
    @software_count = results.count
    results = results.paginate(:per_page => @per_page, :page => params[:page])
    @searches[@asset] = {:results => results}
    @search = results

    render :layout=>false if request.xhr?
  end

  protected

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

  def get_filter_category_ids
    category_ids = []
    unless params[:selected_categories_id].blank?
      category_ids = params[:selected_categories_id]
    end
    category_ids.map(&:to_i)
  end

  def get_filtered_software_list
    params[:query] ||= ""

    filtered_software_list = SoftwareInfo.search_by_query(params[:query])

    if params[:only_softwares]
      params[:only_softwares].collect!{ |software_name| software_name.to_slug }
      filtered_software_list = SoftwareInfo.all.select{ |s| params[:only_softwares].include?(s.identifier) }
      @public_software_selected = false
    end

    category_ids = get_filter_category_ids

    unless category_ids.empty?
      filtered_software_list.select! do |software|
        if software.nil? || software.community.nil?
          false
        else
          result_ids = (software.community.category_ids & category_ids).sort
          result_ids == category_ids.sort
        end
      end
    end

    filtered_software_list
  end

  def get_communities_list software_list
    filtered_community_list = []
      software_list.each do |software|
       if @all_selected || software.public_software?
         filtered_community_list << software.community unless software.community.nil?
       end
    end
    filtered_community_list
  end

  def sort_communities_list communities_list
    communities_list.sort! {|a, b| a.name.downcase <=> b.name.downcase}

    if params[:sort] && params[:sort] == "desc"
      communities_list.reverse!
    elsif params[:sort] && params[:sort] == "relevance"
      communities_list = sort_by_relevance(communities_list, params[:query]){ |community| [community.software_info.finality, community.name] }
    end
    communities_list
  end

  def prepare_software_search_page
    prepare_software_infos_params
    prepare_software_infos_message
    prepare_software_infos_category_groups
    prepare_software_infos_category_enable
  end

  def prepare_software_infos_params
    @titles[:software_infos] = _("Result Search")
    @selected_categories_id = params[:selected_categories_id]
    @selected_categories_id ||= []
    @selected_categories_id = @selected_categories_id.map(&:to_i)
    @all_selected = params[:software_type] == "all"
    @public_software_selected = !@all_selected
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

    @selected_categories = []
    unless @selected_categories_id.empty?
      @message_selected_options = _("Selected options: ")

      @selected_categories = Category.find(@selected_categories_id)
      @message_selected_options += @selected_categories.collect { |category|
        "#{category.name}; "
      }.join()
    end
  end

  def prepare_software_infos_category_groups
    @categories = Category.software_categories.sort{|a, b| a.name <=> b.name}
  end

  def prepare_software_infos_category_enable
    @enabled_check_box = Hash.new
    categories = Category.software_categories

    categories.each do |category|
      if category.software_infos.count > 0
        @enabled_check_box[category] = :enabled
      else
        @enabled_check_box[category] = :disabled
      end
    end
  end
end
