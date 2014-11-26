require_dependency 'search_controller'

class SearchController

  def communities
      unfiltered_list = visible_profiles(Community).select{ |com| com.name.downcase =~ /#{params[:query]}.downcase/}
      list_without_software_and_institution = []
      unfiltered_list.each do |p|
        if p.class == Community and !p.software? and !p.institution?
          list_without_software_and_institution << p
        end
      end
      results = list_without_software_and_institution
      results = results.paginate(:per_page => 24, :page => params[:page])
      @searches[@asset] = {:results => results}
      @search = results
  end

end