class CreateSoftware < Task

  validates_presence_of :requestor_id, :target_id
  validates_presence_of :name

  attr_accessible :name, :finality, :repository_link, :requestor, :environment, :reject_explanation, :license_info

  alias :environment :target
  alias :environment= :target=

  DATA_FIELDS = ['name', 'finality', 'license_info', 'repository_link']
  DATA_FIELDS.each do |field|
    settings_items field.to_sym
  end

  def perform
    community = Community.create!(:name => self.name)

    community.environment = self.environment
    community.add_admin(self.requestor)

    software = SoftwareInfo.create!(:finality => self.finality,
    :repository_link => self.repository_link, :community_id => community.id,
    :license_info => self.license_info)
  end

  def title
    _("New software")
  end

  # def icon
  #   src = image ? image.public_filename(:minor) : '/images/icons-app/community-minor.png'
  #   {:type => :defined_image, :src => src, :name => name}
  # end

  def subject
    name
  end

  def information
    if finality.blank?
      { :message => _('%{requestor} wants to create software %{subject} with no finality.') }
    else
      { :message => _('%{requestor} wants to create software %{subject} with this finality:<p><em>%{finality}</em></p>'),
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
    _('%{requestor} wants to create software %{subject}') % {:requestor => requestor.name, :subject => subject}
  end

  def target_notification_message
    _("User \"%{user}\" just requested to create software %{software}. You have to approve or reject it through the \"Pending Validations\" section in your control panel.\n") % { :user => self.requestor.name, :software => self.name }
  end

  def task_created_message
    _("Your request for registering software %{software} at %{environment} was just sent. Environment administrator will receive it and will approve or reject your request according to his methods and creteria.

      You will be notified as soon as environment administrator has a position about your request.") % { :software => self.name, :environment => self.target }
  end

  def task_cancelled_message
    _("Your request for registering software %{software} at %{environment} was not approved by the environment administrator. The following explanation was given: \n\n%{explanation}") % { :software => self.name, :environment => self.environment, :explanation => self.reject_explanation }
  end

  def task_finished_message
    _('Your request for registering the software "%{software}" was approved. You can access %{environment} now and start using your new software.') % { :software => self.name, :environment => self.environment }
  end

  private

end
