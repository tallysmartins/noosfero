require_dependency 'search_controller'

class SearchController

  def communities
    if params[:type] == "Software"
      softwares = SoftwareInfo.search(params[:name])
      communities = []
      softwares.each do |s|
        communities << s.community
      end
      results = communities
      results = results.paginate(:per_page => 24, :page => params[:page])
      @searches[@asset] = {:results => results}
      @search = results
      puts "-"*80, @searches
      puts "-"*80, @search
    elsif params[:type] == "Institution"
      institutions = Institution.search_institution(params[:intitution_name])
      puts "="*80, institutions
      communities = []
      institutions.each do |s|
        communities << s.community
      end
      results = communities
      puts "_"*80, results
      results = results.paginate(:per_page => 24, :page => params[:page])
      puts "-="*80, results
      @searches[@asset] = {:results => results}
      @search = results
      puts "="*80, @searches
      puts "="*80, @search
    else
      unfiltered_list = visible_profiles(Community).select{ |com| com.name =~ /#{params[:query]}/}
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
end