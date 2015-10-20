class CreateSoftware < Task
  include Rails.application.routes.url_helpers

  validates_presence_of :requestor_id, :target_id
  validates_presence_of :name

  attr_accessible :name, :finality, :repository_link, :requestor, :environment,
                  :reject_explanation, :license_info, :identifier, :another_license_version,
                  :another_license_link

  alias :environment :target
  alias :environment= :target=

  DATA_FIELDS = ['name', 'identifier', 'finality', 'license_info', 'repository_link',
                 'another_license_version', 'another_license_link']
  DATA_FIELDS.each do |field|
    settings_items field.to_sym
  end

  def perform
    software_template = SoftwareHelper.software_template
    if (!software_template.blank? && software_template.is_template)
      template_id = software_template.id
    end

    identifier = self.identifier
    identifier ||= self.name.to_slug

    community = Community.create!(:name => self.name,
                                  :identifier => identifier,
                                  :template_id => template_id)

    community.environment = self.environment
    community.add_admin(self.requestor)

    software = SoftwareInfo.new(:finality => self.finality,
    :repository_link => self.repository_link, :community_id => community.id,
    :license_info => self.license_info)
    software.verify_license_info(self.another_license_version, self.another_license_link)
    software.save!
  end

  def title
    _("New software")
  end

  def subject
    name
  end

  def information
    message = _('%{requestor} wants to create software %{subject} with')
    if finality.blank?
      { :message => message + _(' no finality.') }
    else
      { :message => message + _(' this finality:<p><em>%{finality}</em></p>'),
        :variables => {:finality => finality} }
    end
  end

  def reject_details
    true
  end

  # tells if this request was rejected
  def rejected?
    self.status == Task::Status::CANCELLED
  end

  # tells if this request was appoved
  def approved?
    self.status == Task::Status::FINISHED
  end

  def target_notification_description
    _('%{requestor} wants to create software %{subject}') %
    {:requestor => requestor.name, :subject => subject}
  end

  def target_notification_message
    _("User \"%{user}\" just requested to create software %{software}.
      You have to approve or reject it through the \"Pending Validations\"
      section in your control panel.\n") %
    { :user => self.requestor.name, :software => self.name }
  end

  def task_created_message
    _("Your request for registering software %{software} at %{environment} was
      just sent. Environment administrator will receive it and will approve or
      reject your request according to his methods and criteria.

      You will be notified as soon as environment administrator has a position
      about your request.") %
    { :software => self.name, :environment => self.target }
  end

  def task_cancelled_message
    _("Your request for registering software %{software} at %{environment} was
      not approved by the environment administrator. The following explanation
      was given: \n\n%{explanation}") %
    { :software => self.name,
      :environment => self.environment,
      :explanation => self.reject_explanation }
  end

  def task_finished_message
    _('Your request for registering the software "%{software}" was approved.
      You can access %{url} and finish the registration of your software.') %
    { :software => self.name, :url => mount_url }
  end

  private

  def mount_url
    identifier = Community.where(:name => self.name).first.identifier
    # The use of url_for doesn't allow the /social within the Public Software
    # portal. That's why the url is mounted so 'hard coded'
    url = "#{environment.top_url}/myprofile/#{identifier}/profile_editor/edit_software_community"
  end

end
