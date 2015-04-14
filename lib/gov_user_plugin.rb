class GovUserPlugin < Noosfero::Plugin
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include FormsHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def self.plugin_name
    # FIXME
    "GovUserPlugin"
  end

  def self.plugin_description
    # FIXME
    _("A plugin that does this and that.")
  end

  # Hotspot to insert html without an especific hotspot on view.
  def body_beginning
    return if context.session[:user].nil? or context.session[:hide_incomplete_percentage] == true

    person = context.environment.people.where(:user_id=>context.session[:user]).first

    if context.profile && context.profile.person? and !person.nil?
      @person = person
      @percentege = calc_percentage_registration(person)

      if @percentege >= 0 and @percentege < 100
        expanded_template('incomplete_registration.html.erb')
      end
    end
  end

  def profile_editor_transaction_extras
    single_hash_transactions = { :user => 'user',
                                 :instituton => 'instituton'
    }

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
      return profile_tabs_institution if context.profile.institution?
    end
  end

  def control_panel_buttons
    if context.profile.institution?
      return institution_info_button
    end
  end

  def self.extra_blocks
    {
      InstitutionsBlock => {  :type => [Environment, Person] }
    }
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

  def profile_editor_extras
    profile = context.profile

    if profile.person?
      expanded_template('person_editor_extras.html.erb')
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

  def js_files
    %w(
    vendor/modulejs-1.5.0.min.js
    vendor/jquery.js
    lib/noosfero-root.js
    lib/select-element.js
    lib/select-field-choices.js
    views/complete-registration.js
    views/control-panel.js
    views/create-institution.js
    views/new-community.js
    views/user-edit-profile.js
    initializer.js
    app.js
    )
  end

  def admin_panel_links
    [
      {
        :title => _('Create Institution'),
        :url => {
          :controller => 'gov_user_plugin',
          :action => 'create_institution_admin'
        }
      }
    ]
  end

  protected

  def profile_required_list
    fields = {}
    fields[:person_fields] = %w(cell_phone
    contact_phone
    comercial_phone
    country
    city
    state
    organization_website
    image
    identifier
    name)

    fields[:user_fields] = %w(secondary_email email)
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


  protected

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

  private

  def call_model_transaction(model,name)
    send(name + '_transaction') if context.params.key?(model.to_sym)
  end

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

    manage_user_institutions(user, old_communities, new_communities)
  end

  def institution_info_button
    {
      :title => _('Institution Info'),
      :icon => 'edit-profile-group control-panel-instituton-link',
      :url => {
        :controller => 'software_communities_plugin_myprofile',
        :action => 'edit_institution'
      }
    }
  end

  def manage_user_institutions(user, old_communities, new_communities)
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

  def profile_tabs_institution
    { :title => _('Institution'),
      :id => 'intitution-fields',
      :content => Proc::new do render :partial => 'profile/institution_tab' end,
        :start => true
      }
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
