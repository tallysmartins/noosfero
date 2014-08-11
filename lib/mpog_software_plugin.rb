class MpogSoftwarePlugin < Noosfero::Plugin
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include FormsHelper
  include LibraryHelper

  def self.plugin_name
    "MpogSoftwarePlugin"
  end

  def self.plugin_description
    _("Add Public Software and MPOG features.")
  end

  def signup_extra_contents
    institutions = Institution.all

    Proc::new do
      content_tag(:div,
        required(labelled_form_field(
          _('Secondary e-Mail'),
          text_field(:user, :secondary_email, :id => 'secondary_email_field') +
          content_tag(
          :small, _("If you have a gov email, don't forget to use this email on the primary email") ,:class => 'signup-form',:id =>'secondary-email-balloon')
         )),
      :id => 'signup-secondary-email') +

      content_tag(:div,
        labelled_form_field(
          _('Role'), text_field(:user, :role, :id => 'role_field') +
          content_tag(
          :small,_('If your primary email has one of those sufix: gov.br, jus.br, leg.br or mp.br, dont forget to fill your role in the organization'),:class => 'signup-form',:id =>'role-balloon')),
          :id => 'signup-role'
      ) +

      content_tag(:div,
        labelled_form_field(
          _('Areas of Interest'),
          text_field(:profile_data, :area_interest, :id => 'area_interest_field')+
          content_tag(
          :small,_('Fill with your interest areas'),:class => 'signup-form',:id =>'area-interest-balloon')),
       :id => 'signup-area-interest'
      ) +

      content_tag(:div,
        labelled_form_field(
          _('Institution'),
          text_field(:institution, :name, :id => 'input_institution')+
          content_tag(
            :small, _('Fill with your institution') ,:class => 'signup-form', :id =>'institution-balloon'
          ) +
          content_tag(:div, _("The searched institution does not exist"), :id=>"institution_empty_ajax_message", :class=>"errorExplanation hide-field") +
          link_to(_("Add new institution"), "#", :id=>"create_institution_link", :class=>'button with-text icon-add')+
          hidden_field_tag("user[institution_id]", "", :id => 'user_institution_id')+
          content_tag(:div, "", :id=>"institution_dialog")
        ),
       :id => 'signup-institution'
      )
    end
  end

  def profile_editor_extras
    if context.profile.person?
      expanded_template('person_editor_extras.html.erb')
    elsif context.profile.respond_to? :software_info and !context.profile.software_info.nil?
      expanded_template('software_editor_extras.html.erb')
    elsif context.profile.respond_to? :institution and !context.profile.institution.nil?
      expanded_template('institution_editor_extras.html.erb')
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

      if context.params.has_key?(:controlled_vocabulary)
        controlled_vocabulary_transaction
      end
    elsif context.profile.respond_to?(:user)
      if context.params.has_key?(:user)
        user_transaction
      end
    end
  end

  def profile_tabs
    if context.profile.person?
      { :title => _("Mpog"),
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

  def stylesheet?
    true
  end

  def js_files
    ["mpog-software-validations.js", "mpog-user-validations.js", "mpog-institution-validations.js", "mpog-incomplete-registration.js"]
  end

  def add_new_organization_button
    Proc::new do
      button(:add, _('Create a new software'), :controller => 'mpog_software_plugin_myprofile', :action => 'new_software')
    end
  end

  # FIXME - if in error log apears has_permission?, try to use this method
  def has_permission?(person, permission, target)
    person.has_permission_without_plugins?(permission, target)
  end

  def incomplete_registration
    return if context.session[:user].nil? or context.session[:hide_incomplete_percentage] == true

    person = Person.where(:user_id=>context.session[:user]).first

    unless person.nil?
      @profile_edit_link = link_to _("Complete your profile"), "/myprofile/#{person.identifier}/profile_editor/edit"
      @percentege = calc_percentage_registration(person)
      if @percentege >= 0 and @percentege <= 100
        expanded_template('incomplete_registration.html.erb')
      end
    end
  end


  def manage_software
    [{:title => _('Manage Software'), :url => {:controller => 'mpog_software_plugin', :action => 'archive_software'}}]
  end


  def custom_user_registration_attributes user
    if user.institution
      community = user.institution.community
      community.add_member user.person
    end
  end

  protected

  def calc_percentage_registration person
    required_list = profile_required_list
    empty_fields = profile_required_empty_list person

    percentege = 100 - ((empty_fields.count*100)/required_list.count)
    person.percentage_incomplete = percentege
    person.save(validate: false)
    percentege
  end

 def create_url_to_edit_profile person
    new_url = person.public_profile_url
    new_url[:controller] = 'profile_editor'
    new_url[:action] = 'edit'
    new_url
 end

  def profile_required_list
    required_list = ["cell_phone","contact_phone","institution","comercial_phone","country","city","state","organization_website","role","area_interest","image"]
  end

  def profile_required_empty_list person
    empty_fields = []
    required_list = profile_required_list

    required_list.each do |field|
      if person.send(field).blank?
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
    User.transaction do
      context.profile.user.update_attributes!(context.params[:user])
    end
  end

  def institution_transaction
    if context.params.has_key?(:governmental_power)
      context.profile.institution.governmental_power_id = context.params[:governmental_power]
      context.profile.institution.save!
    end

    if context.params.has_key?(:governmental_sphere)
      context.profile.institution.governmental_sphere_id = context.params[:governmental_sphere]
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

  def add_new_user_search_filter
    expanded_template('user_search/search_filter.html.erb')
  end

  def custom_people_search params
    Person.search(params[:name],
      params[:state],
      params[:city],
      params[:email]
    )
  end

  def controlled_vocabulary_transaction
    ControlledVocabulary.transaction do
      context.profile.software_info.controlled_vocabulary.update_attributes!(context.params[:controlled_vocabulary])
    end
  end
end
