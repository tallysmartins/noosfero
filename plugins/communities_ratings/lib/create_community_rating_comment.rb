class CreateCommunityRatingComment < Task
  include Rails.application.routes.url_helpers

  validates_presence_of :requestor_id, :community_rating_id, :target_id

  settings_items :community_rating_id, :type => Integer, :default => nil
  settings_items :community_rating_comment_id, :type => Integer, :default => nil

  attr_accessible :community_rating_id, :body, :requestor, :reject_explanation, :organization

  before_save :update_comment_body
  # before_save :create_comment

  # belongs_to :target, :class_name => 'Community', :foreign_key => :target_id
  # belongs_to :community_rating

  alias :organization :target
  alias :organization= :target=

  DATA_FIELDS = ['body']
  DATA_FIELDS.each do |field|
    settings_items field.to_sym
  end

  def link_comment_with_its_rating(user_comment)
    rating = CommunityRating.find(self.community_rating_id)
    rating.comment = user_comment
    rating.save
  end

  def create_comment
    if (self.body && !self.body.empty? && !self.body.blank?)
      comment_body = _("Comment waiting for approval")
      comment = Comment.create!(:source => self.target, :body => comment_body, :author => self.requestor)
      self.community_rating_comment_id = comment.id
      link_comment_with_its_rating(comment)
    end
  end

  def get_comment_message
    if self.status == 2
      _("Comment rejected")
    elsif self.status == 3
      self.body
    else
      _("No comment")
    end
  end


  def update_comment_body
    if self.community_rating_comment_id.nil?
      create_comment
    else
      comment = Comment.find_by_id(self.community_rating_comment_id)
      comment.body = get_comment_message
      comment.save
    end
  end

  def title
    _("New Comment")
  end

  def information
    message = _("<div class=\"comment\">%{requestor} wants to create a comment in the \"%{target}\" community.<br> Comment: <br> \"%{body}\"</div>") %
    {:requestor => self.requestor.name, :target => self.target.name, :body => self.body }

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
    _('%{requestor} wants to create a comment in the \"%{target}\" community') %
    {:requestor => self.requestor.name, :target => self.target.name }
  end

  def target_notification_message
    _("User \"%{user}\" just requested to create a comment in the \"%{target}\" community.
      You have to approve or reject it through the \"Pending Validations\"
      section in your control panel.\n") %
    { :user => self.requestor.name, :target => self.target.name }
  end

  def task_created_message

    _("Your request for commenting at %{target} was
      just sent. Environment administrator will receive it and will approve or
      reject your request according to his methods and criteria.

      You will be notified as soon as environment administrator has a position
      about your request.") %
    { :target => self.target.name }
  end

  def task_cancelled_message
    _("Your request for commenting at %{target} was
      not approved by the environment administrator. The following explanation
      was given: \n\n%{explanation}") %
    { :target => self.target.name,
      :explanation => self.reject_explanation }
  end

  def task_finished_message
    _('Your request for commenting was approved.
      You can access %{url} to see your comment.') %
    { :url => mount_url }
  end

  private

  def mount_url
    identifier = self.target.identifier
    # The use of url_for doesn't allow the /social within the Public Software
    # portal. That's why the url is mounted so 'hard coded'
    url = "#{self.environment.top_url}/profile/#{identifier}"
  end

end
