require "ostruct"

class Calendar
  class Event < OpenStruct
    def initialize(attributes)
      attributes["date"] = Date.parse(attributes["date"]) unless attributes["date"].is_a?(Date)
      if attributes["title"] && !attributes["title"].empty?
        attributes["title"] = I18n.t(attributes["title"])
      end
      if attributes["notes"] && !attributes["notes"].empty?
        attributes["notes"] = I18n.t(attributes["notes"])
      end
      super(attributes)
    end

    def as_json
      @table.stringify_keys
    end
  end
end
