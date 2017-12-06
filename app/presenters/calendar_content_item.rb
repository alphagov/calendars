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
      document_type: 'calendar',
      schema_name: 'calendar',
      publishing_app: 'calendars',
      rendering_app: 'calendars',
      locale: 'en',
      details: {
        body: calendar.body,
      },
      public_updated_at: Time.current.to_datetime.rfc3339,
      routes: [
        { type: 'prefix', path: base_path }
      ],
      update_type: update_type,
    }
  end
end
