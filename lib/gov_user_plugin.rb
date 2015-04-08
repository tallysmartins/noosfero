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
    views/complete-registration.js
    initializer.js
    app.js
    )
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

  def user_transaction
    user_editor_institution_actions

    User.transaction do
      context.profile.user.update_attributes!(context.params[:user])
    end
  end

  private

  def call_model_transaction(model,name)
    send(name + '_transaction') if context.params.key?(model.to_sym)
  end

end
