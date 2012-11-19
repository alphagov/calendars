require 'integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "GET /calendars/<calendar>.ics" do
    should "contain all calendar events with an individual calendar" do
      get "/bank-holidays/england-and-wales-2011.ics"

      expected = "BEGIN:VCALENDAR\r\nMETHOD:PUBLISH\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      repository.find_by_division_and_year('england-and-wales','2011').events.each_with_index do |event,i|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nUID:GOVUK#{i+1}\r\nSEQUENCE:1\r\nDTSTAMP:20121017T0100Z\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type

      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "contain all calendar events for combined calendars" do
      get "/bank-holidays/england-and-wales.ics"

      expected = "BEGIN:VCALENDAR\r\nMETHOD:PUBLISH\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"

      repository = Calendar::Repository.new("bank-holidays")
      Calendar.combine(repository.all_grouped_by_division, 'england-and-wales').events.each_with_index do |event, i|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\r\nSUMMARY:#{event.title}\r\nUID:GOVUK#{i+1}\r\nSEQUENCE:1\r\nDTSTAMP:20121017T0100Z\r\nEND:VEVENT\r\n"
      end

      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type
      assert_equal "max-age=3600, public", response.headers["Cache-Control"]
    end

    should "provide neccessary headers for compatibility with Outlook XP/2003" do
      get "/bank-holidays/england-and-wales-2011.ics"

      assert_match "BEGIN:VCALENDAR\r\nMETHOD:PUBLISH", response.body
      assert_match "UID:GOVUK1\r\nSEQUENCE:1\r\nDTSTAMP:", response.body
    end
  end
end
