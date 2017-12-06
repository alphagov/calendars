class SearchPayloadPresenter
  attr_reader :calendar
  delegate :slug,
           :title,
           :description,
           :body,
           :content_id,
           to: :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def self.call(calendar)
    new(calendar).call
  end

  def call
    {
      content_id: content_id,
      rendering_app: 'calendars',
      publishing_app: 'calendars',
      format: 'calendar',
      title: title,
      description: description,
      indexable_content: body,
      link: "/#{slug}",
      content_store_document_type: 'calendar',
    }
  end
end
