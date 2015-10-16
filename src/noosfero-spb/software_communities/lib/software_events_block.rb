class SoftwareEventsBlock < Block

  def self.description
    _('Software community events')
  end

  def help
    _('This block displays the software community events in a list.')
  end

  def content(args={})
    today = DateTime.now.beginning_of_day
    events = self.owner.events.where("start_date >= ? AND end_date >= ?", today, today).order(:start_date)

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
end
