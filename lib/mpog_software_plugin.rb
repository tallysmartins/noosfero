class MpogSoftwarePlugin < Noosfero::Plugin
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include FormsHelper
  include LibraryHelper
  include InstitutionHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def self.plugin_name
    "MpogSoftwarePlugin"
  end

  def self.plugin_description
    _("Add Public Software and MPOG features.")
  end

  def profile_editor_extras
    if context.profile.person?
      expanded_template('person_editor_extras.html.erb')
    elsif context.profile.respond_to? :software_info and !context.profile.software_info.nil?
      if context.profile.software_info.first_edit?
        context.profile.software_info.first_edit = false
        context.profile.software_info.save!
        expanded_template('first_edit_software_community_extras.html.erb')
      end
    end
  end

  def profile_editor_transaction_extras
    if context.profile.respond_to?(:software_info)
      if context.params.has_key?(:software_info)
        software_info_transaction
      end

      if context.params.has_key?(:library)
        libraries_transaction
      end

      if context.params.has_key?(:version)
        license_transaction
      end

      if context.params.has_key?(:language)
        language_transaction
      end

      if context.params.has_key?(:database)
        databases_transaction
      end

      if context.params.has_key?(:operating_system)
        operating_system_transaction
      end
      if context.params.has_key?(:institution) || context.params.has_key?(:governmental_power) || context.params.has_key?(:governmental_sphere)
        institution_transaction
      end

      if context.params.has_key?(:software_categories)
        software_categories_transaction
      end
    elsif context.profile.respond_to?(:user)
      if context.params.has_key?(:user)
        user_transaction
      end
    end
  end

  def profile_editor_controller_filters
    block = proc do
      if request.post? && params[:institution]
        is_admin = environment.admins.include?(current_user.person)

        unless is_admin
          institution = profile.user.institutions

          if !params[:institution].blank? and !params[:institution][:sisp].nil?
            params[:institution][:sisp] = institution.sisp if params[:institution][:sisp] != institution.sisp
          end
        end
      end
    end

    [{
      :type => "before_filter",
      :method_name => "validate_institution_sisp_field_access",
      :options => { :only=>:edit },
      :block => block
    }]
  end

  def profile_tabs
    if context.profile.person?
      { :title => _("Secundary Information"),
        :id => 'mpog-fields',
        :content => Proc::new do render :partial => 'profile_tab' end,
        :start => true }
    elsif context.profile.software?
        { :title => _("Software"),
        :id => 'mpog-fields',
        :content => Proc::new do render :partial => 'software_tab' end,
        :start => true }
    elsif context.profile.institution?
      { :title => _("Institution"),
        :id => 'mpog-fields',
        :content => Proc::new do render :partial => 'institution_tab' end,
        :start => true
      }
    end
  end

  def control_panel_buttons
    if context.profile.software?
      return { :title => _("Software Info"), :icon => "edit-profile-group control-panel-software-link", :url => {:controller => "mpog_software_plugin_myprofile", :action => "edit_software"} }
    elsif context.profile.person?
      return { :title => _("Create a new software"), :icon => "design-editor", :url => {:controller => "mpog_software_plugin_myprofile", :action => "new_software"} }
      return nil
    elsif context.profile.institution?
      return { :title => _("Institution Info"), :icon => "edit-profile-group control-panel-instituton-link", :url => {:controller => "mpog_software_plugin_myprofile", :action => "edit_institution"} }
    end
  end

  def self.extra_blocks
    {
      SoftwaresBlock => {:type => [Environment, Person] },
      SoftwareInformationBlock => {:type => [Community] },
      InstitutionsBlock => {:type => [Environment, Person]},
      DownloadBlock => {:type => [Community]},
      RepositoryBlock => {:type => [Community]},
      CategoriesAndTagsBlock => {:type => [Community]},
      CategoriesSoftwareBlock => {:type => [Environment]},
      SearchCatalogBlock => {:type => [Environment]}
    }
  end

  def stylesheet?
    true
  end

  def js_files
    %w[
      jquery.maskedinput.min.js
      spb-utils.js
      mpog-software.js
      mpog-software-validations.js
      mpog-user-validations.js
      mpog-institution-validations.js
      mpog-incomplete-registration.js
      mpog-search.js
      software-catalog.js
      mpog-software-block.js
    ]
  end

  def add_new_organization_buttons
    Proc::new do
      button(:add, _('Create a new software'), :controller => 'mpog_software_plugin_myprofile', :action => 'new_software')
    end
  end

  # FIXME - if in error log apears has_permission?, try to use this method
  def has_permission?(person, permission, target)
    person.has_permission_without_plugins?(permission, target)
  end

  def profile_blocks_extra_content
    return if context.session[:user].nil? or context.session[:hide_incomplete_percentage] == true

    person = Person.where(:user_id=>context.session[:user]).first

    if context.profile && context.profile.person? and !person.nil?
      @person = person
      @percentege = calc_percentage_registration(person)

      if @percentege >= 0 and @percentege <= 100
        expanded_template('incomplete_registration.html.erb')
      end
    end
  end

  def custom_user_registration_attributes user
    unless context.params[:user][:institution_ids].nil?
      context.params[:user][:institution_ids].delete("")

      context.params[:user][:institution_ids].each do |institution_id|
        institution = Institution.find institution_id
        user.institutions << institution
        institution.community.add_admin(user.person) if institution.community.admins.blank?
      end
    end
    user.save unless user.institution_ids.empty?

    user.institutions.each do |institution|
      community = institution.community
      community.add_member user.person
    end
  end

  def calc_percentage_registration person
    required_list = profile_required_list
    empty_fields = profile_required_empty_list person
    count = required_list[:person_fields].count + required_list[:user_fields].count
    percentege = 100 - ((empty_fields.count*100)/count)
    person.percentage_incomplete = percentege
    person.save(validate: false)
    percentege
  end

  def admin_panel_links
    [{:title => _('Create Institution'), :url => {:controller => 'mpog_software_plugin', :action => 'create_institution_admin'}}]
  end

  protected

  def create_url_to_edit_profile person
    new_url = person.public_profile_url
    new_url[:controller] = 'profile_editor'
    new_url[:action] = 'edit'
    new_url
  end

  def profile_required_list
    fields = Hash.new
    fields[:person_fields] = ["cell_phone","contact_phone","comercial_phone","country","city","state","organization_website", "image", "identifier", "name"]
    fields[:user_fields] = ["secondary_email", "email"]
    fields
  end

  def profile_required_empty_list person
    empty_fields = []
    required_list = profile_required_list

    required_list[:person_fields].each do |field|
      if person.send(field).blank?
        empty_fields << field.sub("_"," ")
      end
    end
    required_list[:user_fields].each do |field|
      if person.user.send(field).blank?
        empty_fields << field.sub("_"," ")
      end
    end
    empty_fields
  end

  def operating_system_transaction
    OperatingSystem.transaction do
      list_operating = OperatingSystemHelper.list_operating_system(context.params[:operating_system])

      if OperatingSystemHelper.valid_list_operating_system?(list_operating)
        OperatingSystem.where(:software_info_id => context.profile.software_info.id).destroy_all
        list_operating.each do |operating_system|
          operating_system.software_info = context.profile.software_info
          operating_system.save!
        end
      else
        raise 'Invalid Operating System fields'
      end
    end
  end

  def user_transaction
    user_editor_institution_actions

    User.transaction do
      context.profile.user.update_attributes!(context.params[:user])
    end
  end

  def institution_transaction
    InstitutionHelper.register_institution_modification context.profile.institution
    if context.params.has_key?(:governmental_power)
      context.profile.institution.governmental_power_id = context.params[:governmental_power]
      context.profile.institution.save!
    end

    if context.params.has_key?(:governmental_sphere)
      context.profile.institution.governmental_sphere_id = context.params[:governmental_sphere]
      context.profile.institution.save!
    end

    if context.params.has_key?(:juridical_nature)
      context.profile.institution.juridical_nature_id = context.params[:juridical_nature]
      context.profile.institution.save!
    end

    if context.params.has_key?(:institution)
      Institution.transaction do
        context.profile.institution.update_attributes!(context.params[:institution])
      end
    end
  end

  def software_info_transaction
    SoftwareInfo.transaction do
      context.profile.software_info.update_attributes!(context.params[:software_info])
    end
  end

  def libraries_transaction
    Library.transaction do
      list_libraries = LibraryHelper.list_libraries(context.params[:library])

      if LibraryHelper.valid_list_libraries?(list_libraries)
        Library.where(:software_info_id=> context.profile.software_info.id).destroy_all

        list_libraries.each do |library|
          library.software_info_id = context.profile.software_info.id
          library.save!
        end
      else
        raise 'Invalid Library fields'
      end
    end
  end

  def databases_transaction
    SoftwareDatabase.transaction do
      list_databases = DatabaseHelper.list_database(context.params[:database])

      if DatabaseHelper.valid_list_database?(list_databases)
        SoftwareDatabase.where(:software_info_id => context.profile.software_info.id).destroy_all
        list_databases.each do |database|
          database.software_info = context.profile.software_info
          database.save!
        end
      else
        raise 'Invalid Database fields'
      end
    end
  end

  def license_transaction
    license = LicenseInfo.find(context.params[:version])
    context.profile.software_info.license_info = license
    context.profile.software_info.save!
  end

  def language_transaction
    SoftwareLanguage.transaction do
      list_language = SoftwareLanguageHelper.list_language(context.params[:language])

      if SoftwareLanguageHelper.valid_list_language?(list_language)
        SoftwareLanguage.where(:software_info_id => context.profile.software_info.id).destroy_all

        list_language.each do |language|
          language.software_info = context.profile.software_info
          language.save!
        end
      else
        raise 'Invalid Software Language fields'
      end
    end
  end

  def add_new_search_filter
    if context.params[:action] == "communities"
      @active_type = if context.params[:type] == "Software"
        "software"
      elsif context.params[:type] == "Institution"
        "institution"
      else
        "community"
      end
      expanded_template('search/search_community_filter.html.erb')
    end
  end

  def software_categories_transaction
    ControlledVocabulary.transaction do
      context.profile.software_info.software_categories.update_attributes!(context.params[:software_categories])
    end
  end

  private

  # Add and remove the user from it's institutions communities
  def user_editor_institution_actions
    user = context.profile.user

    old_communities = []
    context.profile.user.institutions.each do |institution|
      old_communities << institution.community
    end

    new_communities = []
    unless context.params[:user][:institution_ids].nil?
      context.params[:user][:institution_ids].delete("")

      context.params[:user][:institution_ids].each do |id|
        new_communities << Institution.find(id).community
      end
    end

    leave_communities = (old_communities - new_communities)
    enter_communities = (new_communities - old_communities)

    leave_communities.each do |community|
      community.remove_member(user.person)
      user.institutions.delete(community.institution)
    end

    enter_communities.each do |community|
      community.add_member(user.person)
      user.institutions << community.institution
    end
  end

  def show_sisp_field
    current_person = User.find(context.session[:user]).person
    context.environment.admins.include?(current_person)
  end
end
