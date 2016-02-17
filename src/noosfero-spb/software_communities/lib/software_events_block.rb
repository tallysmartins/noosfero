class SoftwareEventsBlock < Block

  settings_items :amount_of_events, :type => :integer, :default => 3
  attr_accessible :amount_of_events

  validates :amount_of_events,
            :presence => true, :numericality => {
              greater_than_or_equal_to: 1
            }

  def self.description
    _('Software community events')
  end

  def help
    _('This block displays the software community events in a list.')
  end

  def default_title
    _('Other events')
  end

  def content(args={})
    block = self

    lambda do |object|
      render(
        :file => 'blocks/software_events',
        :locals => { :block => block }
      )
    end
  end

  def cacheable?
    false
  end

  def get_events
    yesterday = DateTime.yesterday.end_of_day
    self.owner.events.where("start_date > ?", yesterday).order(:start_date, :id).limit(self.amount_of_events)
  end

  def get_events_except event_slug=""
    event_slug = "" if event_slug.nil?

    get_events.where("slug NOT IN (?)", event_slug)
  end

  def has_events_to_display? current_event_slug=""
    not get_events_except(current_event_slug).empty?
  end

  def should_display_title?
    self.box.position != 1
  end
end
