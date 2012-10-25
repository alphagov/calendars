require 'integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "GET /calendars/<calendar>.ics" do
    should "contain all calendar events with an individual calendar" do
      get "/bank-holidays/england-and-wales-2011.ics"

      expected = "BEGIN:VCALENDAR\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\nVERSION:2.0\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      repository.find_by_division_and_year('england-and-wales','2011').events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, @response.body
    end

    should "contain all calendar events for combined calendars" do
      get "/bank-holidays/england-and-wales.ics"

      expected = "BEGIN:VCALENDAR\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\nVERSION:2.0\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      Calendar.combine(repository.all_grouped_by_division, 'england-and-wales').events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, @response.body
     end
  end
end
