# encoding: utf-8

require_relative '../test_helper'

class EventTest < ActiveSupport::TestCase
  context "construction" do
    should "parse a date given as a string" do
      e = Calendar::Event.new("date" => "2012-02-04")
      assert_equal Date.civil(2012, 2, 4), e.date
    end

    should "allow construction with dates as well as string dates" do
      e = Calendar::Event.new("date" => Date.civil(2012, 2, 4))
      assert_equal Date.civil(2012, 2, 4), e.date
    end
  end

  context "as_json in English" do
    should "return a hash representation" do
      I18n.locale = :en
      e = Calendar::Event.new(
        "title" => "bank_holidays.new_year",
        "date" => "02/01/2012",
        "notes" => "common.substitute_day",
        "bunting" => true
      )

      expected = {
        "title" => "New Year’s Day",
        "date" => Date.civil(2012, 1, 2),
        "notes" => "Substitute day",
        "bunting" => true
      }

      assert_equal expected, e.as_json
    end
  end
end
