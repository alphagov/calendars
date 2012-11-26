require 'ostruct'

class Calendar
  class Event < OpenStruct
    def initialize(attributes)
      attributes["date"] = Date.parse(attributes["date"]) unless attributes["date"].is_a?(Date)
      super(attributes)
    end
  end
end
