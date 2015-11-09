class SoftwareEventsBlock < Block

  def self.description
    _('Software community events')
  end

  def help
    _('This block displays the software community events in a list.')
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
    today = DateTime.now.beginning_of_day
    self.owner.events.where("end_date >= ?", today).order(:start_date)
  end

  def get_events_except event_slug=""
    event_slug = "" if event_slug.nil?

    get_events.where("slug NOT IN (?)", event_slug)
  end

  def has_events_to_display?
    not get_events.empty?
  end

  def should_display_title?
    self.box.position != 1
  end
end
