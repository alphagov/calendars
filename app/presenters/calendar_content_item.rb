# Renders a calendar for the publishing-api.
class CalendarContentItem
  attr_reader :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def base_path
    '/' + calendar.slug
  end

  def payload
    {
      title: calendar.title,
      content_id: calendar.content_id,
      format: 'placeholder_calendar',
      publishing_app: 'calendars',
      rendering_app: 'calendars',
      update_type: 'minor',
      locale: 'en',
      public_updated_at: Time.now,
      routes: [
        { type: 'exact', path: base_path }
      ]
    }
  end
end
