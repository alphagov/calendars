# encoding: utf-8
require_relative '../integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "getting ICS version" do
    setup do
      # This timestamp is used to generate the DTSTAMP entries
      File.stubs(:mtime).with(Rails.root.join("REVISION")).returns(Time.parse("2012-10-17 01:00:00"))
    end

    should "contain all events in the given division" do
      path = "/bank-holidays/england-and-wales.ics"
      path_hash = Digest::MD5.hexdigest(path)
      get path

      expected_events = [
        {"date"=>"20110829", "title"=>"Summer bank holiday"},
        {"date"=>"20111226", "title"=>"Boxing Day"},
        {"date"=>"20111227", "title"=>"Christmas Day"},
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

      expected = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"
      expected_events.each_with_index do |event,i|
        expected << "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{event["date"]}\r\nDTSTART;VALUE=DATE:#{event["date"]}\r\nSUMMARY:#{event["title"]}\r\n"
        expected << "UID:#{path_hash}-#{i}@gov.uk\r\nSEQUENCE:0\r\nDTSTAMP:20121017T010000Z\r\nEND:VEVENT\r\n"
      end
      expected << "END:VCALENDAR\r\n"

      assert_equal expected, response.body
      assert_equal "text/calendar", response.content_type
      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "have redirect for old 'ni' division" do
      get "/bank-holidays/ni.ics"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland.ics", response.location
    end
  end
end
