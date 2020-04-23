# encoding: utf-8

require "ics_renderer"

RSpec.describe ICSRenderer do
  context "generating complete ics file" do
    it "generates correct ics header and footer" do
      r = ICSRenderer.new([], "/foo/ics")

      expected =  "BEGIN:VCALENDAR\r\n"
      expected << "VERSION:2.0\r\n"
      expected << "METHOD:PUBLISH\r\n"
      expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
      expected << "CALSCALE:GREGORIAN\r\n"
      expected << "END:VCALENDAR\r\n"

      expect(r.render).to eq(expected)
    end

    it "generates an event for each given event" do
      r = ICSRenderer.new(%i[e1 e2], "/foo/ics")
      allow(r).to receive(:render_event).with(:e1).and_return("Event1 ics\r\n")
      allow(r).to receive(:render_event).with(:e2).and_return("Event2 ics\r\n")

      expected =  "BEGIN:VCALENDAR\r\n"
      expected << "VERSION:2.0\r\n"
      expected << "METHOD:PUBLISH\r\n"
      expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n"
      expected << "CALSCALE:GREGORIAN\r\n"
      expected << "Event1 ics\r\n"
      expected << "Event2 ics\r\n"
      expected << "END:VCALENDAR\r\n"

      expect(r.render).to eq(expected)
    end
  end

  context "generating an event" do
    before do
      @path = "/foo/ics"
      @r = ICSRenderer.new([], @path)
      allow_any_instance_of(ICSRenderer).to receive(:dtstamp).and_return("20121017T0100Z")
    end

    it "generates an event" do
      e = Calendar::Event.new("title" => "An Event", "date" => "2012-04-14")

      allow(Digest::MD5).to receive(:hexdigest).with(@path).once.and_return("hash")

      expected =  "BEGIN:VEVENT\r\n"
      expected << "DTEND;VALUE=DATE:20120415\r\n"
      expected << "DTSTART;VALUE=DATE:20120414\r\n"
      expected << "SUMMARY:An Event\r\n"
      expected << "UID:hash-2012-04-14-AnEvent@gov.uk\r\n"
      expected << "SEQUENCE:0\r\n"
      expected << "DTSTAMP:20121017T0100Z\r\n"
      expected << "END:VEVENT\r\n"

      expect(@r.render_event(e)).to eq(expected)
    end
  end

  context "generating a uid" do
    before do
      @path = "/foo/bar.ics"
      @r = ICSRenderer.new([], @path)
      @hash = Digest::MD5.hexdigest(@path)
      @first_event = Calendar::Event.new("title" => "Somebody’s important event", "date" => Date.new(1982, 5, 28))
      @second_event = Calendar::Event.new("title" => "Another important event", "date" => Date.new(1984, 1, 16))
    end

    it "uses calendar path, event title and event date to create a uid" do
      expect(@r.uid(@first_event)).to eq("#{@hash}-1982-05-28-Somebodysimportantevent@gov.uk")
    end

    it "caches the hash generation" do
      allow(Digest::MD5).to receive(:hexdigest).with(@path).once.and_return(@hash)
      @r.uid(@first_event)
      expect(@r.uid(@second_event)).to eq("#{@hash}-1984-01-16-Anotherimportantevent@gov.uk")
    end
  end

  context "generating dtstamp" do
    before do
      @r = ICSRenderer.new([], "/foo/ics")
    end

    it "returns the mtime of the REVISION file" do
      allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).and_return(Time.zone.parse("2012-04-06 14:53:54Z"))
      expect(@r.dtstamp).to eq("20120406T145354Z")
    end

    it "returns now if the file doesn't exist" do
      Timecop.freeze(Time.zone.parse("2012-11-27 16:13:27")) do
        allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).and_raise(Errno::ENOENT)
        expect(@r.dtstamp).to eq("20121127T161327Z")
      end
    end

    it "caches the result" do
      allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).once.and_return(Time.zone.parse("2012-04-06 14:53:54Z"))
      @r.dtstamp
      expect(@r.dtstamp).to eq("20120406T145354Z")
    end
  end
end
