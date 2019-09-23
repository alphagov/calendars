require "ostruct"

class Calendar
  class Event < OpenStruct
    def initialize(attributes)
      attributes["date"] = Date.parse(attributes["date"]) unless attributes["date"].is_a?(Date)
      if attributes["title"] && attributes["title"].present?
        attributes["title"] = I18n.t(attributes["title"])
      end
      if attributes["notes"] && attributes["notes"].present?
        attributes["notes"] = I18n.t(attributes["notes"])
      end
      super(attributes)
    end

    def as_json
      @table.stringify_keys
    end
  end
end
