class Calendar
  class Year

    def initialize(year, division, data = [])
      @year = year
      @division = division
      @data = data
    end

    def to_s
      @year
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
        "year" => @year,
        "division" => @division.slug,
        "events" => events,
      }
    end
  end
end
