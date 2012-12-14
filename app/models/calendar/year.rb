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
      @upcoming_event ||= events.find {|e| e.date >= Date.today }
    end

    def as_json(options = nil)
      {
        "year" => self.to_s,
        "division" => @division.slug,
        "events" => events,
      }
    end
  end
end
