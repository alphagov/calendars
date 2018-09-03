# encoding: utf-8

require_relative '../integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest
  context "getting ICS version" do
    setup do
      # This timestamp is used to generate the DTSTAMP entries
      File.stubs(:mtime).with(Rails.root.join("REVISION")).returns(Time.parse("2012-10-17 01:00:00"))
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
      should "contain all events in #{calendar}" do
        get calendar_path
        assert_equal response.status, 200

        expected_non_scottish_events = [
          { "date" => "20120102", "title" => I18n.t('bank_holidays.new_year') },
          { "date" => "20120604", "title" => I18n.t('bank_holidays.spring') },
          { "date" => "20120827", "title" => I18n.t('bank_holidays.summer') },
        ]

        expected_scottish_events = [
          { "date" => "20120103", "title" => I18n.t('bank_holidays.new_year') },
          { "date" => "20120604", "title" => I18n.t('bank_holidays.spring') },
          { "date" => "20120806", "title" => I18n.t('bank_holidays.summer') },
        ]

        common_expected_events = [
          { "date" => "20120605", "title" => I18n.t('bank_holidays.queen_diamond') },
          { "date" => "20121225", "title" => I18n.t('bank_holidays.christmas') },
          { "date" => "20121226", "title" => I18n.t('bank_holidays.boxing_day') },
          { "date" => "20130101", "title" => I18n.t('bank_holidays.new_year') },
          { "date" => "20130329", "title" => I18n.t('bank_holidays.good_friday') },
          { "date" => "20131225", "title" => I18n.t('bank_holidays.christmas') },
          { "date" => "20131226", "title" => I18n.t('bank_holidays.boxing_day') },
        ]

        expected_events = if calendar.include?("scotland")
                            expected_scottish_events + common_expected_events
                          else
                            expected_non_scottish_events + common_expected_events
                          end

        assert(
          response.body.start_with?(
            "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nPRODID:-//uk.gov/GOVUK calendars//EN\r\nCALSCALE:GREGORIAN\r\n"
          )
        )

        assert_equal "text/calendar", response.content_type
        assert_equal "max-age=86400, public", response.headers["Cache-Control"]

        expected_events.each do |event|
          end_date = (Date.parse(event["date"]) + 1.day).strftime("%Y%m%d")
          expected = "BEGIN:VEVENT\r\nDTEND;VALUE=DATE:#{end_date}\r\nDTSTART;VALUE=DATE:#{event['date']}\r\nSUMMARY:#{event['title']}\r\n"

          assert(response.body.include?(expected))
        end
      end
    end

    should "have redirect for old 'ni' division" do
      get "/bank-holidays/ni.ics"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland.ics", response.location
    end

    should "404 if the division does not exist" do
      get "/bank-holidays/never-never-land.ics"
      assert_equal 404, response.status
    end
  end
end
