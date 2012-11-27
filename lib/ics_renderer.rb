
class ICSRenderer
  def initialize(events)
    @events = events
  end

  def render
    output = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\n"
    output << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
    output << "CALSCALE:GREGORIAN\r\n"
    @events.each do |event|
      output << "BEGIN:VEVENT\r\n"
      output << "DTEND;VALUE=DATE:#{ event.date.strftime("%Y%m%d") }\r\n"
      output << "DTSTART;VALUE=DATE:#{ event.date.strftime("%Y%m%d") }\r\n"
      output << "SUMMARY:#{ event.title }\r\n"
      output << "END:VEVENT\r\n"
    end
    output << "END:VCALENDAR\r\n"
  end
end
