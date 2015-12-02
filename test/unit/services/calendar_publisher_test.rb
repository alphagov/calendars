require 'test_helper'

class CalendarPublisherTest < ActiveSupport::TestCase
  def test_publishing_to_publishing_api
    Services.publishing_api.expects(:put_content).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", valid_payload_for('placeholder'))
    Services.publishing_api.expects(:publish).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", 'minor')

    calendar = Calendar.find('bank-holidays')

    CalendarPublisher.new(calendar).publish
  end
end
