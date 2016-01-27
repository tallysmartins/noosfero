# encoding: UTF-8

require_dependency 'search_controller'

class SearchController

  DEFAULT_SOFTWARE_SORT = 'rating'

  def self.catalog_list
    { :public_software => ["Software Público", "software_infos"],
      :sisp_software => ["SISP", "sisp"] }
  end

  def communities
    @titles[:communities] = _("Communities Search")
    delete_communities = []
    valid_communities_string = Community.get_valid_communities_string
    Community.all.each{|community| delete_communities << community.id unless eval(valid_communities_string)}

    @scope = visible_profiles(Community)
    @scope = @scope.where(["id NOT IN (?)", delete_communities]) unless delete_communities.empty?

    full_text_search
  end

  def software_infos
    software_public_condition_block = lambda do |software|
      (!@public_software_selected || software.public_software?) && (!software.sisp)
    end

    prepare_software_search_page(:software_infos, &software_public_condition_block)
    results = filter_software_infos_list(&software_public_condition_block)
    @software_count = results.count
    results = results.paginate(:per_page => @per_page, :page => params[:page])

    @searches[@asset] = {:results => results}
    @search = results

    render :layout=>false if request.xhr?
  end

  def sisp
    sisp_condition_block = lambda{|software| software.sisp }

    prepare_software_search_page(:sisp, &sisp_condition_block)
    results = filter_software_infos_list(&sisp_condition_block)
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

  def filter_software_infos_list &software_condition_block
    filtered_software_list = get_filtered_software_list
    filtered_community_list = get_communities_list(filtered_software_list, &software_condition_block)
    sort_communities_list filtered_community_list
  end

  def get_filter_category_ids
    category_ids = []
    unless params[:selected_categories_id].blank?
      category_ids = params[:selected_categories_id]
    end

    category_ids = category_ids.map{|id| [id.to_i, Category.find(id.to_i).all_children.map(&:id)]}
    category_ids.flatten.uniq
  end

  def get_filtered_software_list
    params[:query] ||= ""
    visible_communities = visible_profiles(Community)

    filtered_software_list = SoftwareInfo.search_by_query(params[:query], environment)

    if params[:only_softwares] && params[:only_softwares].any?{ |word| !word.blank? }
      params[:only_softwares].collect!{ |software_name| software_name.to_slug }
      #FIX-ME: This query is not appropriate
      filtered_software_list = SoftwareInfo.all.select{ |s| params[:only_softwares].include?(s.identifier) }
      @public_software_selected = false
    end

    filtered_software_list = filtered_software_list.select{ |software| visible_communities.include?(software.community) }
    category_ids = get_filter_category_ids

    unless category_ids.empty?
      filtered_software_list.select! do |software|
        !(software.community.category_ids & category_ids).empty?
      end
    end

    filtered_software_list
  end

  def get_communities_list software_list, &software_condition_block
    filtered_community_list = []
      software_list.each do |software|
       if software_condition_block.call(software)
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
    elsif params[:sort] && params[:sort] == "rating"
      communities_list = sort_by_average_rating(communities_list)
    end
    communities_list
  end

  def prepare_software_search_page title, &software_condition_block
    prepare_software_infos_params(title)
    prepare_software_infos_message
    prepare_software_infos_category_groups(&software_condition_block)
    prepare_software_infos_category_enable
  end

  def prepare_software_infos_params title
    @titles[title.to_sym] = _("Result Search")
    params[:sort] ||= DEFAULT_SOFTWARE_SORT

    @selected_categories_id = params[:selected_categories_id]
    @selected_categories_id ||= []
    @selected_categories_id = @selected_categories_id.map(&:to_i)
    @all_selected = params[:software_type] == "all"
    @public_software_selected = !@all_selected
    @per_page = prepare_per_page
  end

  def prepare_per_page
    return 15 if params[:software_display].nil?

    if params[:software_display].downcase == "all"
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

  def prepare_software_infos_category_groups &software_condition_block
    @categories = []
    software_category = environment.categories.find_by_name("Software")
    @categories = software_category.children.sort if software_category
    @categories = @categories.select{|category| category.software_infos.any?{|software| software_condition_block.call(software)}}
    @categories.sort!{|a, b| a.name <=> b.name}
  end

  def prepare_software_infos_category_enable
    @enabled_check_box = Hash.new

    @categories.each do |category|
      if category.software_infos.count > 0
        @enabled_check_box[category] = :enabled
      else
        @enabled_check_box[category] = :disabled
      end
    end
  end
end
