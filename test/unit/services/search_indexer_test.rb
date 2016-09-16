require 'test_helper'

class SearchIndexerTest < ActiveSupport::TestCase
  def test_indexing_to_rummager
    registerable_calendar = RegisterableCalendar.new(
      Rails.root + 'lib/data/bank-holidays.json'
    )
    Services.rummager.expects(:add_document).with(
      'edition',
      '/bank-holidays',
      content_id: '58f79dbd-e57f-4ab2-ae96-96df5767d1b2',
      rendering_app: "calendars",
      publishing_app: "calendars",
      format: "custom-application",
      title: "UK bank holidays",
      description:  "Find out when bank holidays are in England, Wales, Scotland and Northern Ireland - including past and future bank holidays",
      indexable_content: "",
      link: '/bank-holidays',
    )

    SearchIndexer.call(registerable_calendar)
  end
end
