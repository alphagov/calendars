require 'test_helper'

class CalendarPublisherTest < ActiveSupport::TestCase
  def test_publishing_to_publishing_api
    Services.publishing_api.expects(:put_content_item).with(
      "/bank-holidays",
      valid_payload_for('placeholder')
    )

    calendar = Calendar.find('bank-holidays')

    CalendarPublisher.new(calendar).publish
  end
end
