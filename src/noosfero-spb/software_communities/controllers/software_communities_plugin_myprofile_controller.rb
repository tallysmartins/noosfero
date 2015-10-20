class SoftwareCommunitiesPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  protect 'edit_software', :profile, :except => [:destroy_profile]

  def index
  end

  def new_software
    set_software_as_template

    @community = Community.new(params[:community])
    @community.environment = environment

    @license_info = LicenseInfo.find_by_id(params[:license][:license_infos_id]) if params[:license]
    @license_info ||= LicenseInfo.new

    @software_info = SoftwareInfo.new(params[:software_info])
    @software_info.community = @community
    @software_info.license_info = @license_info

    control_software_creation
    update_software_highlight_errors
  end

  def edit_software
    update_software_atributes

    return unless request.post?

    @software_info = create_software
    software_info_insert_models.call(@list_libraries, 'libraries')
    software_info_insert_models.call(@list_languages, 'software_languages')
    software_info_insert_models.call(@list_databases, 'software_databases')
    software_info_insert_models.call(@list_operating_systems, 'operating_systems')

    begin
      raise NotAdminException unless can_change_public_software?
      @software_info.update_attributes!(params[:software])

      @community = @software_info.community
      @community.update_attributes!(params[:community])

      if params[:commit] == _('Save and Configure Community')
        redirect_to :controller => 'profile_editor', :action => 'edit'
      else
        redirect_to :controller => 'profile_editor', :action => 'index'
        session[:notice] = _('Software updated successfully')
      end
    rescue NotAdminException, ActiveRecord::RecordInvalid => invalid
      update_new_software_errors
      session[:notice] = _('Could not update software')
    end
  end

  private

  def can_change_public_software?
    if !user.is_admin?(environment)
      if params[:software][:public_software]
        @software_info.errors.add(:public_software, _("You don't have permission to change public software status"))
        return false
      end

      if params[:software].keys.any?{|key| ["e_ping","e_mag","icp_brasil","e_arq","intern"].include?(key)}
        @software_info.errors.add(:base, _("You don't have permission to change public software attributes"))
        return false
      end
    end
    return true
  end

  def add_software_erros
      @errors = []
      if @community
        error = @community.errors.delete(:identifier)
        @errors |= [_("Domain %s") % error.first ] if error
        @errors |= @community.errors.full_messages
      end
      @errors |= @software_info.errors.full_messages if @software_info
      @errors |= @license_info.errors.full_messages if @license_info
  end

  def control_software_creation
    if request.post?
      valid_models = @community.valid?
      valid_models &= @software_info.valid?
      valid_models &= @license_info.valid?
      if valid_models
        send_software_to_moderation
      else
        add_software_erros
      end
    end
  end

  def software_info_insert_models
    proc { |list,model_attr|
      @software_info.send(model_attr).destroy_all
      list.collect!{|m| @software_info.send(model_attr) << m } unless list.nil?
    }
  end

  def create_software
    @software_info = @profile.software_info
    another_license_version = nil
    another_license_link = nil
    if params[:license]
      @license = LicenseInfo.find(params[:license][:license_infos_id])
      @software_info.license_info = @license

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

    if  !user.is_admin?
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
    @non_admin_status = 'disabled' unless user.is_admin?(environment)

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
    software_template = SoftwareHelper.software_template
    software_valid = !software_template.blank? && !params['community'].blank?
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

  def update_new_software_errors
    if request.post?
      @community.valid? if @community
      @software_info.valid? if @software_info
      @license_info.valid? if @license_info
      add_software_erros
    end

  def update_software_highlight_errors
    @error_community_name = @community.errors.include?(:name) ? "highlight-error" : "" if @community
    @error_software_acronym = @software_info.errors.include?(:acronym) ? "highlight-error" : "" if @software_info
    @error_software_domain = @community.errors.include?(:identifier) ? "highlight-error" : "" if @community
    @error_software_finality = @software_info.errors.include?(:finality) ? "highlight-error" : "" if @software_info
    @error_software_license = @license_info.errors.include?(:version) ? "highlight-error" : "" if @license_info
  end
end

class NotAdminException < Exception; end
