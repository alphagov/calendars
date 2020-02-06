# encoding: utf-8

require_relative "../test_helper"
require "ics_renderer"

class ICSRendererTest < ActiveSupport::TestCase
  context "generating complete ics file" do
    should "generate correct ics header and footer" do
      r = ICSRenderer.new([], "/foo/ics")

      expected =  "BEGIN:VCALENDAR\r\n"
      expected << "VERSION:2.0\r\n"
      expected << "METHOD:PUBLISH\r\n"
      expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
      expected << "CALSCALE:GREGORIAN\r\n"
      expected << "END:VCALENDAR\r\n"

      assert_equal expected, r.render
    end

    should "generate an event for each given event" do
      r = ICSRenderer.new(%i[e1 e2], "/foo/ics")
      r.expects(:render_event).with(:e1).returns("Event1 ics\r\n")
      r.expects(:render_event).with(:e2).returns("Event2 ics\r\n")

      expected =  "BEGIN:VCALENDAR\r\n"
      expected << "VERSION:2.0\r\n"
      expected << "METHOD:PUBLISH\r\n"
      expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
      expected << "CALSCALE:GREGORIAN\r\n"
      expected << "Event1 ics\r\n"
      expected << "Event2 ics\r\n"
      expected << "END:VCALENDAR\r\n"

      assert_equal expected, r.render
    end
  end

  context "generating an event" do
    setup do
      @path = "/foo/ics"
      @r = ICSRenderer.new([], @path)
      ICSRenderer.any_instance.stubs(:dtstamp).returns("20121017T0100Z")
    end

    should "generate an event" do
      e = Calendar::Event.new("title" => "An Event", "date" => "2012-04-14")

      Digest::MD5.expects(:hexdigest).with(@path).once.returns("hash")

      expected =  "BEGIN:VEVENT\r\n"
      expected << "DTEND;VALUE=DATE:20120415\r\n"
      expected << "DTSTART;VALUE=DATE:20120414\r\n"
      expected << "SUMMARY:An Event\r\n"
      expected << "UID:hash-2012-04-14-AnEvent@gov.uk\r\n"
      expected << "SEQUENCE:0\r\n"
      expected << "DTSTAMP:20121017T0100Z\r\n"
      expected << "END:VEVENT\r\n"

      assert_equal expected, @r.render_event(e)
    end
  end

  context "generating a uid" do
    setup do
      @path = "/foo/bar.ics"
      @r = ICSRenderer.new([], @path)
      @hash = Digest::MD5.hexdigest(@path)
      @first_event = Calendar::Event.new("title" => "An important event", "date" => Date.new(1982, 5, 28))
      @second_event = Calendar::Event.new("title" => "Another important event", "date" => Date.new(1984, 1, 16))
    end

    should "use calendar path, event title and event date to create a uid" do
      assert_equal "#{@hash}-1982-05-28-Animportantevent@gov.uk", @r.uid(@first_event)
    end

    should "cache the hash generation" do
      Digest::MD5.expects(:hexdigest).with(@path).once.returns(@hash)
      @r.uid(@first_event)
      assert_equal "#{@hash}-1984-01-16-Anotherimportantevent@gov.uk", @r.uid(@second_event)
    end
  end

  context "generating dtstamp" do
    setup do
      @r = ICSRenderer.new([], "/foo/ics")
    end

    should "return the mtime of the REVISION file" do
      File.expects(:mtime).with(Rails.root.join("REVISION")).returns(Time.zone.parse("2012-04-06 14:53:54Z"))
      assert_equal "20120406T145354Z", @r.dtstamp
    end

    should "return now if the file doesn't exist" do
      Timecop.freeze(Time.zone.parse("2012-11-27 16:13:27")) do
        File.expects(:mtime).with(Rails.root.join("REVISION")).raises(Errno::ENOENT)
        assert_equal "20121127T161327Z", @r.dtstamp
      end
    end

    should "cache the result" do
      File.expects(:mtime).with(Rails.root.join("REVISION")).once.returns(Time.zone.parse("2012-04-06 14:53:54Z"))
      @r.dtstamp
      assert_equal "20120406T145354Z", @r.dtstamp
    end
  end
end
