# encoding: utf-8
require_relative '../integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "getting ICS version" do
    should "contain all events for the specified division and year" do
      get "/bank-holidays/england-and-wales-2012.ics"

      expected_events = [
        {"date"=>"20120102", "title"=>"New Year’s Day"},
        {"date"=>"20120604", "title"=>"Spring bank holiday"},
        {"date"=>"20120605", "title"=>"Queen’s Diamond Jubilee"},
        {"date"=>"20120827", "title"=>"Summer bank holiday"},
        {"date"=>"20121225", "title"=>"Christmas Day"},
        {"date"=>"20121226", "title"=>"Boxing Day"},
      ]

      expected = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"
      expected_events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event["date"]}\r\nDTSTART;VALUE=DATE:#{event["date"]}\r\nSUMMARY:#{event["title"]}\r\nEND:VEVENT\r\n"
      end
      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type
      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "contain all events for all yeads in the given division" do
      get "/bank-holidays/england-and-wales.ics"

      expected_events = [
        {"date"=>"20120102", "title"=>"New Year’s Day"},
        {"date"=>"20120604", "title"=>"Spring bank holiday"},
        {"date"=>"20120605", "title"=>"Queen’s Diamond Jubilee"},
        {"date"=>"20120827", "title"=>"Summer bank holiday"},
        {"date"=>"20121225", "title"=>"Christmas Day"},
        {"date"=>"20121226", "title"=>"Boxing Day"},
        {"date"=>"20130101", "title"=>"New Year’s Day"},
        {"date"=>"20130329", "title"=>"Good Friday"},
        {"date"=>"20131225", "title"=>"Christmas Day"},
        {"date"=>"20131226", "title"=>"Boxing Day"},
      ]

      expected = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"
      expected_events.each do |event|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event["date"]}\r\nDTSTART;VALUE=DATE:#{event["date"]}\r\nSUMMARY:#{event["title"]}\r\nEND:VEVENT\r\n"
      end
      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type
      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
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
