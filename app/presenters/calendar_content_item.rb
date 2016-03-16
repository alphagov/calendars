# Renders a calendar for the publishing-api.
class CalendarContentItem
  attr_reader :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def base_path
    '/' + calendar.slug
  end

  def update_type
    'minor'
  end

  def content_id
    calendar.content_id
  end

  def payload
    {
      title: calendar.title,
      base_path: base_path,
      format: 'placeholder_calendar',
      publishing_app: 'calendars',
      rendering_app: 'calendars',
      locale: 'en',
      public_updated_at: Time.current.to_datetime.rfc3339,
      routes: [
        { type: 'exact', path: base_path }
      ]
    }
  end
end