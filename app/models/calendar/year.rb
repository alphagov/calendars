require 'ostruct'

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
        date = Date.parse(e["date"])
        OpenStruct.new(e.merge("date" => date))
      end
    end

  end
end
