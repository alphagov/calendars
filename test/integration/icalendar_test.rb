require_relative '../integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "GET /calendars/<calendar>.ics" do
    should "contain all calendar events with an individual calendar" do
      get "/bank-holidays/england-and-wales-2012.ics"

      expected = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      repository.find_by_division_and_year('england-and-wales','2012').events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type

      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "contain all calendar events for combined calendars" do
      get "/bank-holidays/england-and-wales.ics"

      expected = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      Calendar.combine(repository.all_grouped_by_division, 'england-and-wales').events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type
      assert_equal "max-age=3600, public", response.headers["Cache-Control"]
    end

    should "have redirects for old 'ni' division" do
      get "/bank-holidays/ni.ics"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland.ics", response.location

      get "/bank-holidays/ni-2012.ics"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland-2012.ics", response.location

      get "/bank-holidays/ni-2013.ics"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland-2013.ics", response.location
    end
  end
end
