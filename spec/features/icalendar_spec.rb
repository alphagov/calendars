# encoding: utf-8

RSpec.feature "icalendar" do
  context "getting ICS version" do
    before do
      # This timestamp is used to generate the DTSTAMP entries
      allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).and_return(Time.zone.parse("2012-10-17 01:00:00"))
    end

    calendars = {
      "welsh" => "/gwyliau-banc/cymru-a-lloegr.ics",
      "welsh-scotland" => "/gwyliau-banc/yr-alban.ics",
      "welsh-nothern-ireland" => "/gwyliau-banc/gogledd-iwerddon.ics",
      "english" => "/bank-holidays/england-and-wales.ics",
      "english-scotland" => "/bank-holidays/scotland.ics",
      "english-northern-ireland" => "/bank-holidays/northern-ireland.ics",
    }

    calendars.each do |calendar, calendar_path|
      it "contains all events in #{calendar}" do
        visit calendar_path
        expect(page.status_code).to eq(200)

        expected_non_scottish_events = [
          { "date" => "20120102", "title" => I18n.t("bank_holidays.new_year") },
          { "date" => "20120604", "title" => I18n.t("bank_holidays.spring") },
          { "date" => "20120827", "title" => I18n.t("bank_holidays.summer") },
        ]

        expected_scottish_events = [
          { "date" => "20120103", "title" => I18n.t("bank_holidays.new_year") },
          { "date" => "20120604", "title" => I18n.t("bank_holidays.spring") },
          { "date" => "20120806", "title" => I18n.t("bank_holidays.summer") },
        ]

        common_expected_events = [
          { "date" => "20120605", "title" => I18n.t("bank_holidays.queen_diamond") },
          { "date" => "20121225", "title" => I18n.t("bank_holidays.christmas") },
          { "date" => "20121226", "title" => I18n.t("bank_holidays.boxing_day") },
          { "date" => "20130101", "title" => I18n.t("bank_holidays.new_year") },
          { "date" => "20130329", "title" => I18n.t("bank_holidays.good_friday") },
          { "date" => "20131225", "title" => I18n.t("bank_holidays.christmas") },
          { "date" => "20131226", "title" => I18n.t("bank_holidays.boxing_day") },
        ]

        expected_events = if calendar.include?("scotland")
                            expected_scottish_events + common_expected_events
                          else
                            expected_non_scottish_events + common_expected_events
                          end

        expect(page.body).to start_with("BEGIN:VCALENDAR\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n")

        expect(page.response_headers["Content-Type"]).to eq("text/calendar; charset=utf-8")
        expect(page.response_headers["Cache-Control"]).to eq("max-age=86400, public")

        expected_events.each do |event|
          end_date = (Date.parse(event["date"]) + 1.day).strftime("%Y%m%d")
          expected = "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{end_date}\r\nDTSTART;VALUE=DATE:#{event['date']}\r\nSUMMARY:#{event['title']}\r\n"

          expect(page.body).to include(expected)
        end
      end
    end

    it "has redirect for old 'ni' division" do
      visit "/bank-holidays/ni.ics"
      expect(page.current_url).to eq("http://www.example.com/bank-holidays/northern-ireland.ics")
    end

    it "404s if the division does not exist" do
      visit "/bank-holidays/never-never-land.ics"
      expect(page.status_code).to eq(404)
    end
  end
end
