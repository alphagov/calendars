class SearchIndexer
  attr_reader :registerable_calendar
  delegate :slug, to: :registerable_calendar

  def initialize(registerable_calendar)
    @registerable_calendar = registerable_calendar
  end

  def self.call(registerable_calendar)
    new(registerable_calendar).call
  end

  def call
    Services.rummager.add_document(document_type, document_id, payload)
  end

private

  def document_type
    'edition'
  end

  def document_id
    "/#{slug}"
  end

  def payload
    SearchPayloadPresenter.call(registerable_calendar)
  end
end
