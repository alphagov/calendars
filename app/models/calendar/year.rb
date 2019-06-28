class Calendar
  class Year
    def initialize(year_str, division, data = [])
      @year_str = year_str
      @division = division
      @data = data
    end

    def to_s
      @year_str
    end

    def events
      @events ||= @data.map do |e|
        Event.new(e)
      end
    end

    def upcoming_event
      @upcoming_event ||= events.find { |e| e.date >= Time.zone.today }
    end

    def upcoming_events
      @upcoming_events ||= events.select { |e| e.date >= Time.zone.today }
    end

    def past_events
      @past_events ||= events.select { |e| e.date < Time.zone.today }
    end
  end
end
