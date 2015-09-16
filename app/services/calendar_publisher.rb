class CalendarPublisher
  def initialize(calendar)
    @calendar = calendar
  end

  def publish
    Services.publishing_api.put_content_item(rendered.base_path, rendered.payload)
  end

private

  def rendered
    @rendered ||= CalendarContentItem.new(@calendar)
  end
end
