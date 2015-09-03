class CreateCommunityRatingComment < Task
  include Rails.application.routes.url_helpers

  validates_presence_of :requestor_id, :community_rating, :target_id

  attr_accessible :community_rating, :source, :body, :requestor, :reject_explanation, :organization, :institution_id
  belongs_to :source, :class_name => 'Community', :foreign_key => :source_id
  belongs_to :community_rating

  alias :organization :target
  alias :organization= :target=

  DATA_FIELDS = ['body']
  DATA_FIELDS.each do |field|
    settings_items field.to_sym
  end


  def perform
    if (self.body.empty? || self.body.blank?)
      self.body = _("No comment")
    end

    comment = Comment.create!(:source => self.source, :body => self.body, :author => self.requestor)
    self.community_rating.comment = comment
    self.community_rating.save!
  end

  def title
    _("New Comment")
  end

  def information
    message = _("<div class=\"comment\">%{requestor} wants to create a comment in the \"%{source}\" community.<br> Comment: <br> \"%{body}\"</div>") %
    {:requestor => self.requestor.name, :source => self.source.name, :body => self.body }

    {:message => message}
  end

  def reject_details
    true
  end

  def icon
    {:type => :profile_image, :profile => requestor, :url => requestor.url}
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
    _('%{requestor} wants to create a comment in the \"%{source}\" community') %
    {:requestor => self.requestor.name, :source => self.source.name }
  end

  def target_notification_message
    _("User \"%{user}\" just requested to create a comment in the \"%{source}\" community.
      You have to approve or reject it through the \"Pending Validations\"
      section in your control panel.\n") %
    { :user => self.requestor.name, :source => self.source.name }
  end

  def task_created_message

    _("Your request for commenting at %{source} was
      just sent. Environment administrator will receive it and will approve or
      reject your request according to his methods and criteria.

      You will be notified as soon as environment administrator has a position
      about your request.") %
    { :source => self.source.name }
  end

  def task_cancelled_message
    _("Your request for commenting at %{source} was
      not approved by the environment administrator. The following explanation
      was given: \n\n%{explanation}") %
    { :source => self.source.name,
      :explanation => self.reject_explanation }
  end

  def task_finished_message
    _('Your request for commenting was approved.
      You can access %{url} to see your comment.') %
    { :url => mount_url }
  end

  private

  def mount_url
    identifier = self.source.identifier
    # The use of url_for doesn't allow the /social within the Public Software
    # portal. That's why the url is mounted so 'hard coded'
    url = "#{self.environment.top_url}/profile/#{identifier}"
  end

end
