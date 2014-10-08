class MpogSoftwarePluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def archive_software
    puts "="*80
    nil
  end

  def new_software
    @errors = []
    @community = Community.new(params[:community])
    @community.environment = environment
    @software_info = SoftwareInfo.new(params[:software_info])
   #@list_libraries = LibraryHelper.list_libraries(params[:library])
   #@list_languages = SoftwareLanguageHelper.list_language(params[:language])
   #@list_databases = DatabaseHelper.list_database(params[:database])
   #@software_categories = SoftwareCategories::new params[:software_categories]
   #@list_operating_systems = OperatingSystemHelper.list_operating_system(params[:operating_system])
   @license_info = if params[:license_info].nil?
     LicenseInfo::new
   else
     LicenseInfo.find(:first, :conditions =>["version = ?","#{params[:license_info][:version]}"])
   end

   #if not @list_libraries.nil?
   #  @list_libraries.each do |library|
   #    @software_info.libraries << library
   #  end
   #end

   #if not @list_languages.nil?
   #  @list_languages.each do |language|
   #    @software_info.software_languages << language
   #  end
   #end

   #if not @list_databases.nil?
   #  @list_databases.each do |database|
   #    @software_info.software_databases << database
   #  end
   #end

   #if not @list_operating_systems.nil?
   #  @list_operating_systems.each do |operating_system|
   #    @software_info.operating_systems << operating_system
   #  end
   #end

   valid_community = request.post? && @community.valid?
   valid_software_info = request.post? && @software_info.valid?
   #valid_license = (request.post? && @license_info.valid?)
   #valid_libraries = @list_libraries.empty? || LibraryHelper.valid_list_libraries?(@list_libraries)
   #valid_database = DatabaseHelper.valid_list_database?(@list_databases)
   #valid_language = SoftwareLanguageHelper.valid_list_language?(@list_languages)
   #valid_operating_system = OperatingSystemHelper.valid_list_operating_system?(@list_operating_systems)
   #valid_software_categories = request.post? && @software_categories.valid?

   if valid_software_info && valid_community 
     @community = Community.create_after_moderation(user, {:environment => environment}.merge(params[:community]), @software_info )
    redirect_to :controller => 'memberships', :action => 'index'

     unless params[:q].nil?
       admins = params[:q].split(/,/).map{|n| environment.people.find n.to_i}

       admins.each do |admin|
         @community.add_member(admin)
         @community.add_admin(admin)
       end
     end

   else
   #  @list_libraries.each do |lib|
   #    @errors |= lib.errors.full_messages
   #  end
   #  
   #  @list_languages.each do |lng|
   #    @errors |= lng.errors.full_messages
   #  end
   #
   #  @list_databases.each do |db|
   #    @errors |= db.errors.full_messages
   #  end

   #  @list_operating_systems.each do |os|
   #    @errors |= os.errors.full_messages
   #  end

     @errors |= @community.errors.full_messages
     @errors |= @software_info.errors.full_messages
     @errors |= @license_info.errors.full_messages
   #  @errors |= @software_categories.errors.full_messages
   #end
  end

  def search_offerers
    arg = params[:q].downcase
    result = environment.people.find(:all, :conditions => ['LOWER(name) LIKE ?', "%#{arg}%"])
    render :text => prepare_to_token_input(result).to_json
  end
end
end
