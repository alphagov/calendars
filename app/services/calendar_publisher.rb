class CalendarPublisher
  def initialize(calendar)
    @calendar = calendar
  end

  def publish
    Services.publishing_api.put_content(rendered.content_id, rendered.payload)
    Services.publishing_api.publish(rendered.content_id)
    Services.publishing_api.patch_links(rendered.content_id, links: rendered.links)
  end

private

  def rendered
    @rendered ||= CalendarContentItem.new(@calendar)
  end
end
