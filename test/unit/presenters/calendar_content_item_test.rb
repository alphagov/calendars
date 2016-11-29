require 'test_helper'
require 'govuk-content-schema-test-helpers/test_unit'

class CalendarContentItemTest < ActiveSupport::TestCase
  include GovukContentSchemaTestHelpers::TestUnit

  def test_payload_is_valid_against_schema
    calendar = Calendar.find('bank-holidays')

    payload = CalendarContentItem.new(calendar).payload

    assert_valid_against_schema payload, 'generic'
  end

  def test_payload_contains_correct_data
    calendar = Calendar.find('bank-holidays')

    payload = CalendarContentItem.new(calendar).payload

    assert_equal 'UK bank holidays', payload[:title]
  end

  def test_base_path_is_correct
    calendar = Calendar.find('bank-holidays')

    base_path = CalendarContentItem.new(calendar).base_path

    assert_equal '/bank-holidays', base_path
  end
end
