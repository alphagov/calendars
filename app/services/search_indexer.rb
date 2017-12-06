class SearchIndexer
  attr_reader :calendar
  delegate :slug, to: :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def self.call(calendar)
    new(calendar).call
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
    SearchPayloadPresenter.call(calendar)
  end
end
