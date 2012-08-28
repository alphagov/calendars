require 'integration_test_helper'

class CalendarsTest < ActionDispatch::IntegrationTest

  should "give a 404 status when a calendar does not exist" do
    visit '/maternity'
    assert page.status_code == 404
  end

  should "give a 404 when asked for a division that doesn't exist" do
    visit "/when-do-the-clocks-change/A188770693.ics"
    assert page.status_code == 404

    visit "/bank-holidays/england-and-wales-or-elsewhere.ics"
    assert page.status_code == 404
  end

  context 'GET /bank-holidays/' do

    should "show a tab for each division" do
      get "/bank-holidays"

      repository = Calendar::Repository.new("bank-holidays")
      repository.all_grouped_by_division.each do |division, item|
        assert_select "#tabs li a.#{division}"
        assert_select "#guide-nav ##{division}"
      end
    end

    should "show a table for each calendar with the correct caption" do
      get "/bank-holidays"

      repository = Calendar::Repository.new("bank-holidays")
      repository.all_grouped_by_division.each do |division, item|
        assert_select "##{division} table", :count => item[:calendars].size

        item[:calendars].each do |year,cal|
          assert_select "##{division} table caption", "#{cal.year} bank holidays in #{cal.formatted_division}"
        end
      end
    end

    should "show a row for each bank holiday in the table" do
      get "/bank-holidays"

      repository = Calendar::Repository.new("bank-holidays")
      repository.all_grouped_by_division.each do |division, item|
        item[:calendars].each do |year,cal|
          assert_select "##{division} table" do
            cal.events.each do |event|
              assert_select "tr" do
                assert_select "td.calendar_date", :text => event.date.strftime('%d %B')
                assert_select "td.calendar_day", :text => event.date.strftime('%A')
                assert_select "td.calendar_title", :text => event.title
                assert_select "td.calendar_notes", :text => event.notes
              end
            end
          end
        end
      end
    end
  end

end
