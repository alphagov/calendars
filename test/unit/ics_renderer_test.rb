# encoding: utf-8
require_relative '../test_helper'
require 'ics_renderer'

class ICSRendererTest < ActiveSupport::TestCase

  should "generate correct ics header and footer" do
    r = ICSRenderer.new([])

    expected =  "BEGIN:VCALENDAR\r\nVERSION:2.0\r\n"
    expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
    expected << "CALSCALE:GREGORIAN\r\n"
    expected << "END:VCALENDAR\r\n"

    assert_equal expected, r.render
  end

  should "generate an event for each given event" do
    e1 = Calendar::Event.new("title" => "An Event", "date" => "2012-04-14")
    e2 = Calendar::Event.new("title" => "Another event", "date" => "2012-06-03")
    r = ICSRenderer.new([e1, e2])

    expected =  "BEGIN:VCALENDAR\r\nVERSION:2.0\r\n"
    expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
    expected << "CALSCALE:GREGORIAN\r\n"

    expected << "BEGIN:VEVENT\r\n"
    expected << "DTEND;VALUE=DATE:20120414\r\n"
    expected << "DTSTART;VALUE=DATE:20120414\r\n"
    expected << "SUMMARY:An Event\r\n"
    expected << "END:VEVENT\r\n"

    expected << "BEGIN:VEVENT\r\n"
    expected << "DTEND;VALUE=DATE:20120603\r\n"
    expected << "DTSTART;VALUE=DATE:20120603\r\n"
    expected << "SUMMARY:Another event\r\n"
    expected << "END:VEVENT\r\n"

    expected << "END:VCALENDAR\r\n"

    assert_equal expected, r.render
  end
end
