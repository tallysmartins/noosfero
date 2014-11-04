class MpogSoftwarePluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def archive_software
    puts "="*80
    nil
  end

  def edit_institution
    @show_sisp_field = environment.admins.include?(current_user.person)
    @estate_list = NationalRegion.find(:all, :conditions=>["national_region_type_id = ?", 2], :order=>"name")

    @institution = @profile.institution

    if request.post?
      @institution.community.update_attributes(params[:community])
      @institution.update_attributes(params[:institutions].except(:governmental_power, :governmental_sphere, :juridical_nature))

      if @institution.type == "PublicInstitution"
        begin
          govPower = GovernmentalPower.find params[:institutions][:governmental_power]
          govSphere = GovernmentalSphere.find params[:institutions][:governmental_sphere]
          jur_nature = JuridicalNature.find params[:institutions][:juridical_nature]

          @institution.juridical_nature = jur_nature
          @institution.governmental_power = govPower
          @institution.governmental_sphere = govSphere
          @institution.save
        rescue
          @institution.errors.add(:governmental_fields, _("Could not find Governmental Power or Governmental Sphere"))
        end
      end

      flash[:errors] = @institution.errors.full_messages unless @institution.valid?
    end
  end

  def new_software
    @errors = []

    software_template = Community["software"]
    if (!software_template.blank? && software_template.is_template)
      params["community"]["template_id"] = software_template.id unless params["community"].blank?
    end

    @community = Community.new(params[:community])
    @community.environment = environment
    @software_info = SoftwareInfo.new(params[:software_info])
    @license_info = if params[:license_info].nil?
     LicenseInfo::new
   else
     LicenseInfo.find(:first, :conditions =>["version = ?","#{params[:license_info][:version]}"])
   end
   valid_community = request.post? && @community.valid?
   valid_software_info = request.post? && @software_info.valid?
   valid_license = (request.post? && @license_info.valid?)
   if valid_software_info && valid_license && valid_community
      @community = Community.create_after_moderation(user, {:environment => environment}.merge(params[:community]), @software_info, @license_info )

      unless params[:q].nil?
        admins = params[:q].split(/,/).map{|n| environment.people.find n.to_i}

        admins.each do |admin|
          @community.add_member(admin)
          @community.add_admin(admin)
        end
      end

      if environment.enabled?("admin_must_approve_new_communities")
        session[:notice] = _('Your new software request will be evaluated by an administrator. You will be notified.')
        redirect_to user.admin_url
      else
        redirect_to :controller => 'profile_editor', :action => 'edit', :profile => @community.identifier
      end
    else

     @errors |= @community.errors.full_messages
     @errors |= @software_info.errors.full_messages
     @errors |= @license_info.errors.full_messages
   end
  end

  def search_offerers
    arg = params[:q].downcase
    result = environment.people.find(:all, :conditions => ['LOWER(name) LIKE ?', "%#{arg}%"])
    render :text => prepare_to_token_input(result).to_json
  end

  def edit_software
    @software_info = @profile.software_info
    @list_libraries = @software_info.libraries
    @list_databases = @software_info.software_databases
    @list_languages = @software_info.software_languages
    @list_operating_systems = @software_info.operating_systems
    @software_categories = @software_info.software_categories
    @software_categories = SoftwareCategories.new if @software_categories.blank?

    @disabled_public_software_field = disabled_public_software_field

    if request.post?
      params[:software][:public_software] ||= false
      @software_info = @profile.software_info
      @license = LicenseInfo.find(params[:license][:license_infos_id])
      @software_info.license_info = @license
      @software_info.update_attributes(params[:software])

      @list_libraries = LibraryHelper.list_libraries(params[:library])
      @list_languages = SoftwareLanguageHelper.list_language(params[:language])
      @list_databases = DatabaseHelper.list_database(params[:database])
      @software_categories = SoftwareCategories::new params[:software_categories]
      @list_operating_systems = OperatingSystemHelper.list_operating_system(params[:operating_system])
      @software_info.software_categories = @software_categories unless params[:software_categories].nil?

      if not @list_libraries.nil?
        @software_info.libraries.destroy_all
        @list_libraries.each do |library|
          @software_info.libraries << library
        end
      end

      if not @list_languages.nil?
        @software_info.software_languages.destroy_all
        @list_languages.each do |language|
          @software_info.software_languages << language
        end
      end

      if not @list_databases.nil?
        @software_info.software_databases.destroy_all
        @list_databases.each do |database|
          @software_info.software_databases << database
        end
      end

      if not @list_operating_systems.nil?
        @software_info.operating_systems.destroy_all
        @list_operating_systems.each do |operating_system|
          @software_info.operating_systems << operating_system
        end
      end

      begin
        @software_info.save!
        if params[:commit] == _('Save and Configure Community')
          redirect_to :controller => 'profile_editor', :action => 'edit'
        else
          redirect_to :controller => 'profile_editor', :action => 'index'
        end
      rescue ActiveRecord::RecordInvalid => invalid
      end
    end
  end

  def disabled_public_software_field
    !environment.admins.include?(current_user.person)
  end

  def community_must_be_approved
  end
end
