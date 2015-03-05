class SoftwareCommunitiesPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def edit_institution
    @show_sisp_field = environment.admins.include?(current_user.person)
    @state_list = NationalRegion.find(:all, :conditions =>
                                            { :national_region_type_id =>  2 },
                                             :order => 'name')
    @institution = @profile.institution
    update_institution if request.post?
  end

  def new_software
    set_software_as_template

    @community = Community.new(params[:community])
    @community.environment = environment
    @software_info = SoftwareInfo.new(params[:software_info])

    @license_info = if params[:license].blank? or params[:license][:license_infos_id].blank?
      LicenseInfo.new
    else
      LicenseInfo.find(params[:license][:license_infos_id])
    end

    control_software_creation
  end

  def search_offerers
    arg = params[:q].downcase
    result = environment.people.find(:all,
                                     :conditions => [ 'LOWER(name) LIKE ?', "%#{arg}%"])
    render :text => prepare_to_token_input(result).to_json
  end

  def edit_software
    update_software_atributes

    return unless request.post?

    @software_info = constroy_software
    software_info_insert_models.call(@list_libraries, 'libraries')
    software_info_insert_models.call(@list_languages, 'software_languages')
    software_info_insert_models.call(@list_databases, 'software_databases')
    software_info_insert_models.call(@list_operating_systems, 'operating_systems')

    begin
      @software_info.save!

      @community = @software_info.community
      @community.update_attributes!(params[:community])

      if params[:commit] == _('Save and Configure Community')
        redirect_to :controller => 'profile_editor', :action => 'edit'
      else
        redirect_to :controller => 'profile_editor', :action => 'index'
        session[:notice] = _('Software updated successfully')
      end
    rescue ActiveRecord::RecordInvalid => invalid
      session[:notice] = _('Could not update software')
    end
  end

  def disabled_public_software_field
    !environment.admins.include?(current_user.person)
  end

  def community_must_be_approved
  end

  private

  def add_software_erros
      @errors = []
      @errors |= @community.errors.full_messages
      @errors |= @software_info.errors.full_messages
      @errors |= @license_info.errors.full_messages
  end

  def control_software_creation
    valid_models = request.post? && (@community.valid? && @software_info.valid? && @license_info.valid?)
    if valid_models
      send_software_to_moderation
    else
      add_software_erros
    end
  end

  def update_institution
    @institution.community.update_attributes(params[:community])
    @institution.update_attributes(params[:institutions].except(:governmental_power, :governmental_sphere, :juridical_nature))
    if @institution.type == "PublicInstitution"
      begin
        governmental_updates
      rescue
        @institution.errors.add(:governmental_fields,
                                _("Could not find Governmental Power or Governmental Sphere"))
      end
    end
    flash[:errors] = @institution.errors.full_messages unless @institution.valid?
  end

  def governmental_updates
    gov_power = GovernmentalPower.find params[:institutions][:governmental_power]
    gov_sphere = GovernmentalSphere.find params[:institutions][:governmental_sphere]
    jur_nature = JuridicalNature.find params[:institutions][:juridical_nature]

    @institution.juridical_nature = jur_nature
    @institution.governmental_power = gov_power
    @institution.governmental_sphere = gov_sphere
    @institution.save
  end

  def software_info_insert_models
    proc { |list,model_attr|
      @software_info.send(model_attr).destroy_all
      list.collect!{|m| @software_info.send(model_attr) << m } unless list.nil?
    }
  end

  def constroy_software
    params[:software][:public_software] ||= false
    @software_info = @profile.software_info
    @license = LicenseInfo.find(params[:license][:license_infos_id])
    @software_info.license_info = @license
    @software_info.update_attributes(params[:software])

    another_license_version = nil
    another_license_link = nil
    if params[:license]
      another_license_version = params[:license][:version]
      another_license_link = params[:license][:link]
    end

    @software_info.verify_license_info(another_license_version, another_license_link)

    create_list_model_helpers

    @software_info
  end

  def create_list_model_helpers
    @list_libraries = LibraryHelper.list_library(params[:library])
    @list_languages = SoftwareLanguageHelper.list_language(params[:language])
    @list_databases = DatabaseHelper.list_database(params[:database])
    @list_operating_systems = OperatingSystemHelper.list_operating_system(params[:operating_system])
  end

  def send_software_to_moderation
    another_license_version = ""
    another_license_link = ""
    if params[:license]
      another_license_version = params[:license][:version]
      another_license_link = params[:license][:link]
    end
    @software_info = SoftwareInfo.create_after_moderation(user,
                        params[:software_info].merge({
                          :environment => environment,
                          :name => params[:community][:name],
                          :identifier => params[:community][:identifier],
                          :image_builder => params[:community][:image_builder],
                          :license_info => @license_info,
                          :another_license_version => another_license_version,
                          :another_license_link => another_license_link }))

    add_admin_to_community

    if  !environment.admins.include?(current_user.person)
      session[:notice] = _('Your new software request will be evaluated by an'\
                           'administrator. You will be notified.')
      redirect_to user.admin_url
    else
      redirect_to :controller => 'profile_editor',
                  :action => 'edit',
                  :profile => @community.identifier
    end
  end

  def update_software_atributes
    @software_info = @profile.software_info
    @list_libraries = @software_info.libraries
    @list_databases = @software_info.software_databases
    @list_languages = @software_info.software_languages
    @list_operating_systems = @software_info.operating_systems
    @disabled_public_software_field = disabled_public_software_field

    @license_version = @software_info.license_info.version
    @license_id = @software_info.license_info.id
    @another_license_version = ""
    @another_license_link = ""

    license_another = LicenseInfo.find_by_version("Another")
    if license_another && @software_info.license_info_id == license_another.id
      @license_version = "Another"
      @another_license_version = @software_info.license_info.version
      @another_license_link = @software_info.license_info.link
    end
  end

  def set_software_as_template
    software_template = Community['software']
    software_valid = !software_template.blank? && software_template.is_template && !params['community'].blank?
    if software_valid
      params['community']['template_id'] = software_template.id if software_valid
    end
  end

  def add_admin_to_community
    unless params[:q].nil?
      admins = params[:q].split(/,/).map{ |n| environment.people.find n.to_i }
      admins.each do |admin|
        @community.add_member(admin)
        @community.add_admin(admin)
      end
    end
  end
end
