class SoftwareEventsBlock < Block

  def self.description
    _('Software community events')
  end

  def help
    _('This block displays the software community events in a list.')
  end

  def content(args={})
    events = community_events

    block = self

    lambda do |object|
      render(
        :file => 'blocks/software_events',
        :locals => { :block => block, :events => events }
      )
    end
  end

  def cacheable?
    false
  end

  def community_events
    today = DateTime.now.beginning_of_day
    self.owner.events.where("end_date >= ?", today).order(:start_date)
  end
end
