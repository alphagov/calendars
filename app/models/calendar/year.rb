class Calendar
  class Year

    def initialize(year, data = [])
      @year = year
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
  end
end
