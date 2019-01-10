class CalendarEventSchema
  def initialize(calendar)
    @calendar = calendar
  end

  def structured_data
    formatted_events = @calendar.divisions.map do |division|
      future_events(division).map do |event|
        formatted_event(division, event)
      end
    end

    formatted_events.flatten.sort_by { |event| event[:startDate] }
  end

private

  def formatted_event(division, event)
    {
      "@context": "http://schema.org/",
      "@type": "Event",
      name: I18n.t(event.title),
      description: description(division, event),
      startDate: event.date.to_time.beginning_of_day.localtime.iso8601,
      endDate: event.date.to_time.end_of_day.localtime.iso8601,
      duration: "P1D",
      location: {
        "@type": "AdministrativeArea",
        address: I18n.t(division.title),
        name: I18n.t(division.title)
      }
    }
  end

  def description(division, event)
    if event.notes.present?
      "#{bank_holiday} #{location(division)} (#{I18n.t(event.notes).downcase})"
    else
      "#{bank_holiday} #{location(division)}"
    end
  end

  def bank_holiday
    I18n.t("common.bank_holiday")
  end

  def location(division)
    I18n.t("#{division.title}_in")
  end

  def future_events(division)
    division.events.select { |event| event.date > DateTime.yesterday }
  end
end
