require "test_helper"
require "govuk-content-schema-test-helpers/test_unit"

class FaqPresenterTest < ActiveSupport::TestCase
  include GovukContentSchemaTestHelpers::TestUnit

  def test_uses_bank_holiday_body_for_bank_holidays
    expected = [
      q_and_a("England and Wales", "The next bank holiday in England and Wales is Good Friday on the 6th of April"),
      q_and_a("Scotland", "The next bank holiday in Scotland is Good Friday on the 6th of April"),
      q_and_a("Northern Ireland", "The next bank holiday in Northern Ireland is Good Friday on the 6th of April"),
    ]

    Timecop.travel(Date.parse("2012-03-24")) do
      scope = "bank-holidays"
      calendar = Calendar.find(scope)
      content_item = CalendarContentItem.new(calendar).payload

      presenter = FaqPresenter.new(scope, calendar, content_item)

      assert_equal expected, presenter.metadata["mainEntity"]
    end
  end

  def test_uses_wdtcc_body_for_wdtcc
    expected = [
      q_and_a("When do the clocks change?", "The clocks advance on the 25th of March"),
    ]

    Timecop.travel(Date.parse("2012-03-24")) do
      scope = "when-do-the-clocks-change"
      calendar = Calendar.find(scope)
      content_item = CalendarContentItem.new(calendar).payload

      presenter = FaqPresenter.new(scope, calendar, content_item)

      assert_equal expected, presenter.metadata["mainEntity"]
    end
  end

private

  def q_and_a(question, answer)
    {
      "@type" => "Question",
      "name" => question,
      "acceptedAnswer" => {
        "@type" => "Answer",
        "text" => answer,
      },
    }
  end
end
