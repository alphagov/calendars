require 'integration_test_helper'

class IcalendarTest < ActionDispatch::IntegrationTest

  context "GET /calendars/<calendar>.ics" do
    should "contain all calendar events with an individual calendar" do
      get "/bank-holidays/england-and-wales-2011.ics"

      output = "BEGIN:VCALENDAR\nPRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN\nCALSCALE:GREGORIAN\nVERSION:2.0\n"

      repository = Calendar::Repository.new("bank-holidays")
      repository.find_by_division_and_year('england-and-wales','2011').events.each do |event|
        output += "BEGIN:VEVENT\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\nSUMMARY:#{event.title}\nEND:VEVENT\n"
      end

      output += "END:VCALENDAR\n"

      assert_equal output, @response.body
    end

    should "contain all calendar events for combined calendars" do
      get "/bank-holidays/england-and-wales.ics"

      output = "BEGIN:VCALENDAR\nPRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN\nCALSCALE:GREGORIAN\nVERSION:2.0\n"

      repository = Calendar::Repository.new("bank-holidays")
      Calendar.combine(repository.all_grouped_by_division, 'england-and-wales').events.each do |event|
        output += "BEGIN:VEVENT\nDTEND;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\nDTSTART;VALUE=DATE:#{event.date.strftime('%Y%m%d')}\nSUMMARY:#{event.title}\nEND:VEVENT\n"
      end

      output += "END:VCALENDAR\n"

      assert_equal output, @response.body
     end
  end
end