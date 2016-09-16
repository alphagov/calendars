class SearchPayloadPresenter
  attr_reader :registerable_calendar
  delegate :slug,
           :title,
           :description,
           :indexable_content,
           :content_id,
           to: :registerable_calendar

  def initialize(registerable_calendar)
    @registerable_calendar = registerable_calendar
  end

  def self.call(registerable_calendar)
    new(registerable_calendar).call
  end

  def call
    {
      content_id: content_id,
      rendering_app: 'calendars',
      publishing_app: 'calendars',
      format: 'custom-application',
      title: title,
      description: description,
      indexable_content: indexable_content,
      link: "/#{slug}"
    }
  end
end
