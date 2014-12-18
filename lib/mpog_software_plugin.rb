class MpogSoftwarePlugin < Noosfero::Plugin
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include FormsHelper
  include LibraryHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def self.plugin_name
    'MpogSoftwarePlugin'
  end

  def self.plugin_description
    _('Add Public Software and MPOG features.')
  end

  def profile_editor_extras
    if context.profile.person?
      expanded_template('person_editor_extras.html.erb')
    elsif context.profile.respond_to?(:software_info) &&
      !context.profile.software_info.nil?

      if context.profile.software_info.first_edit?
        context.profile.software_info.first_edit = false
        context.profile.software_info.save!
        expanded_template('first_edit_software_community_extras.html.erb')
      end
    end
  end

  def profile_editor_transaction_extras
    single_hash_transactions = { :user => 'user',
                                 :software_info => 'software_info',
                                 :version => 'license', :language => 'language',
                                 :operating_system => 'operating_system',
                                 :software_categories => 'software_categories',
                                 :instituton => 'instituton',
                                 :library => 'libraries' }

    single_hash_transactions.each do |model, transaction|
      call_model_transaction(model, transaction)
    end
  end

  def profile_editor_controller_filters
    block = proc do
      if request.post? && params[:institution]
        is_admin = environment.admins.include?(current_user.person)

        unless is_admin
          institution = profile.user.institutions

          if !params[:institution].blank? && !params[:institution][:sisp].nil?
            if params[:institution][:sisp] != institution.sisp
              params[:institution][:sisp] = institution.sisp
            end
          end
        end
      end
    end

    [{
      :type => 'before_filter',
      :method_name => 'validate_institution_sisp_field_access',
      :options => { :only => :edit },
      :block => block
    }]
  end

  def profile_tabs
    if context.profile.community?
      profile_tabs_software if context.profile.software?
      profile_tabs_institution
    end
  end

  def control_panel_buttons
    if context.profile.software?
      return software_info_button
    elsif context.profile.person?
      return create_new_software_button
    elsif context.profile.institution?
      return institution_info_button
    end
  end

  def self.extra_blocks
    {
      SoftwaresBlock => { :type => [Environment, Person]  },
      SoftwareInformationBlock => {  :type => [Community]  },
      InstitutionsBlock => {  :type => [Environment, Person] },
      DownloadBlock => { :type => [Community] },
      RepositoryBlock => { :type => [Community] },
      CategoriesAndTagsBlock => { :type => [Community] },
      CategoriesSoftwareBlock => { :type => [Environment] },
      SearchCatalogBlock => { :type => [Environment] }
    }
  end

  def stylesheet?
    true
  end

  def js_files
    %w(
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
    )
  end

  def add_new_organization_buttons
    proc do
      button(
        :add,
        _('Create a new software'),
        :controller => 'mpog_software_plugin_myprofile',
        :action => 'new_software'
      )
    end
  end

  # FIXME - if in error log apears has_permission?, try to use this method
  def has_permission?(person, permission, target)
    person.has_permission_without_plugins?(permission, target)
  end

  def profile_blocks_extra_content
    return if context.session[:user].nil? ||
      !context.session[:hide_incomplete_percentage].blank?

    person = Person.where(:user_id => context.session[:user]).first
    puts "="*80,person,"="*80
    call_percentage_profile_template(person)
  end

  def custom_user_registration_attributes(user)
    return  if context.params[:user][:institution_ids].nil?
    context.params[:user][:institution_ids].delete('')

    update_user_institutions(user)

    user.institutions.each do |institution|
      community = institution.community
      community.add_member user.person
    end
  end

  def calc_percentage_registration(person)
    required_list = profile_required_list
    empty_fields = profile_required_empty_list person
    count = required_list[:person_fields].count +
            required_list[:user_fields].count
    percentege = 100 - ((empty_fields.count * 100) / count)
    person.percentage_incomplete = percentege
    person.save(validate: false)
    percentege
  end

  def admin_panel_links
    [
      {
        :title => _('Create Institution'),
        :url => {
          :controller => 'mpog_software_plugin',
          :action => 'create_institution_admin'
        }
      }
    ]
  end

  protected

  def create_url_to_edit_profile person
    new_url = person.public_profile_url
    new_url[:controller] = 'profile_editor'
    new_url[:action] = 'edit'
    new_url
  end

  def profile_required_list
    fields = {}
    fields[:person_fields] = %w('cell_phone',
                                'contact_phone',
                                'comercial_phone',
                                'country',
                                'city',
                                'state',
                                'organization_website',
                                'image',
                                'identifier',
                                'name')

    fields[:user_fields] = %w('secondary_email', 'email')
    fields
  end

  def profile_required_empty_list(person)
    empty_fields = []
    required_list = profile_required_list

    required_list[:person_fields].each do |field|
      empty_fields << field.sub('_',' ') if person.send(field).blank?
    end
    required_list[:user_fields].each do |field|
      empty_fields << field.sub('_',' ') if person.user.send(field).blank?
    end
    empty_fields
  end

  def operating_system_transaction
    OperatingSystem.transaction do
      list_operating = OperatingSystemHelper.list_operating_system(
        context.params[:operating_system]
      )

      if OperatingSystemHelper.valid_list_operating_system?(list_operating)
        OperatingSystem.where(
          :software_info_id => context.profile.software_info.id
        ).destroy_all

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
    institution.date_modification = DateTime.now
    institution.save
    institution_models = %w(governmental_power governmental_sphere
                            juridical_nature)

    institution_models.each do |model|
      call_institution_transaction(model)
    end

    if context.params.has_key?(:institution)
      Institution.transaction do
        context.profile.
          institution.
          update_attributes!(context.params[:institution])
      end
    end
  end

  def software_info_transaction
    SoftwareInfo.transaction do
      context.profile.
        software_info.
        update_attributes!(context.params[:software_info])
    end
  end

  def libraries_transaction
    Library.transaction do
      list_libraries = LibraryHelper.list_libraries(context.params[:library])

      if LibraryHelper.valid_list_libraries?(list_libraries)
        Library.where(
          :software_info_id=> context.profile.software_info.id
        ).destroy_all

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
        SoftwareDatabase.where(
          :software_info_id => context.profile.software_info.id
        ).destroy_all

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
      list_language = SoftwareLanguageHelper.list_language(
        context.params[:language]
      )

      if SoftwareLanguageHelper.valid_list_language?(list_language)
        SoftwareLanguage.where(
          :software_info_id => context.profile.software_info.id
        ).destroy_all

        list_language.each do |language|
          language.software_info = context.profile.software_info
          language.save!
        end
      else
        raise 'Invalid Software Language fields'
      end
    end
  end

  def software_categories_transaction
    ControlledVocabulary.transaction do
      context.profile
        .software_info
        .software_categories
        .update_attributes!(context.params[:software_categories])
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
      context.params[:user][:institution_ids].delete('')

      context.params[:user][:institution_ids].each do |id|
        new_communities << Institution.find(id).community
      end
    end

    manage_user_institutions(user, leave_communities, enter_communities)
  end

  def show_sisp_field
    current_person = User.find(context.session[:user]).person
    context.environment.admins.include?(current_person)
  end

  def call_model_transaction(model,name)
    send(name + '_transaction') if context.params.key?(model.to_sym)
  end

  def call_institution_transaction(model)
    context.profile.institution.send(model + '_id = ',
                                     context.params[model.to_sym])
    context.profile.institution.save!
  end

  def software_info_button
    {
      :title => _('Software Info'),
      :icon => 'edit-profile-group control-panel-software-link',
      :url => {
        :controller => 'mpog_software_plugin_myprofile',
        :action => 'edit_software'
      }
    }
  end

  def create_new_software_button
    {
      :title => _('Create a new software'),
      :icon => 'design-editor',
      :url => {
        :controller => 'mpog_software_plugin_myprofile',
        :action => 'new_software'
      }
    }
  end

  def institution_info_button
    {
      :title => _('Institution Info'),
      :icon => 'edit-profile-group control-panel-instituton-link',
      :url => {
        :controller => 'mpog_software_plugin_myprofile',
        :action => 'edit_institution'
      }
    }
  end

  def manage_user_institutions(leave_communities, enter_communities)
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

  def profile_tabs_software
    { :title => _('Software'),
      :id => 'mpog-fields',
      :content => proc do render :partial => 'software_tab' end,
      :start => true }
  end

  def profile_tabs_institution
    { :title => _('Institution'),
      :id => 'mpog-fields',
      :content => Proc::new do render :partial => 'institution_tab' end,
      :start => true
    }
  end

  def call_percentage_profile_template(person)
    if context.profile && context.profile.person? && !person.nil?
      @person = person
      @percentege = calc_percentage_registration(person)

      if @percentege >= 0 && @percentege <= 100
        expanded_template('incomplete_registration.html.erb')
      end
    end
  end

  def update_user_institutions(user)
    context.params[:user][:institution_ids].each do |institution_id|
      institution = Institution.find institution_id
      user.institutions << institution

      if institution.community.admins.blank?
        institution.community.add_admin(user.person)
      end
    end
    user.save unless user.institution_ids.empty?
  end
end
