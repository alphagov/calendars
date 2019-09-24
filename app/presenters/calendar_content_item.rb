# Renders a calendar for the publishing-api.
class CalendarContentItem
  GDS_ORGANISATION_ID = "af07d5a5-df63-4ddc-9383-6a666845ebe9".freeze

  attr_reader :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def base_path
    "/" + calendar.slug
  end

  def update_type
    "minor"
  end

  def content_id
    calendar.content_id
  end

  def payload
    {
      title: calendar.title,
      description: calendar.description,
      base_path: base_path,
      document_type: "calendar",
      schema_name: "calendar",
      publishing_app: "calendars",
      rendering_app: "calendars",
      locale: "en",
      details: {
        body: calendar.body,
      },
      public_updated_at: Time.current.to_datetime.rfc3339,
      routes: [
        { type: "prefix", path: base_path },
      ],
      update_type: update_type,
    }
  end

  def links
    {
      "primary_publishing_organisation": [GDS_ORGANISATION_ID],
    }
  end
end
