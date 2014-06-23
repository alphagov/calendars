# encoding: utf-8
require_relative "../integration_test_helper"

class BankHolidaysTest < ActionDispatch::IntegrationTest

  should "display the bank holidays page" do
    Timecop.travel("2012-12-14")

    visit "/bank-holidays"

    within "head" do
      assert page.has_selector?("title", text: "UK bank holidays - GOV.UK")
      desc = page.find("meta[name=description]")
      assert_equal "Find out when bank holidays are in England, Wales, Scotland and Northern Ireland - including past and future bank holidays", desc["content"]

      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/england-and-wales.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/england-and-wales.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/scotland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/scotland.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/northern-ireland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/northern-ireland.ics']")
    end

    within "#content" do
      within "header" do
        assert page.has_content?("UK bank holidays")
      end

      within "article" do
        within ".nav-tabs" do
          tab_labels = page.all("ul li a").map(&:text)

          assert_equal ["England and Wales", "Scotland", "Northern Ireland"], tab_labels
        end

        within ".tab-content" do
          within "#england-and-wales" do
            assert page.has_link?("Add bank holidays for England and Wales to your calendar", href: "/bank-holidays/england-and-wales.ics")

            assert_bank_holiday_table title: "Upcoming bank holidays in England and Wales", year: "2012", rows: [
              ["2012"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ]
            assert_bank_holiday_table title: "Upcoming bank holidays in England and Wales", year: "2013", rows: [
              ["2013"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["29 March", "Friday", "Good Friday"],
              ["1 April", "Monday", "Easter Monday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["26 August", "Monday", "Summer bank holiday"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ]

            assert_bank_holiday_table title: "Past bank holidays in England and Wales", year: "2012", rows: [
              ["2012"],
              ["27 August", "Monday", "Summer bank holiday"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday (substitute day)"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["9 April", "Monday", "Easter Monday"],
              ["6 April", "Friday", "Good Friday"],
              ["2 January", "Monday", "New Year’s Day (substitute day)"],
            ]
          end

          within "#scotland" do
            assert page.has_link?("Add bank holidays for Scotland to your calendar", href: "/bank-holidays/scotland.ics")

            assert_bank_holiday_table title: "Upcoming bank holidays in Scotland", year: "2012", rows: [
              ["2012"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ]
            assert_bank_holiday_table title: "Upcoming bank holidays in Scotland", year: "2013", rows: [
              ["2013"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["2 January", "Wednesday", "2nd January"],
              ["29 March", "Friday", "Good Friday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["5 August", "Monday", "Summer bank holiday"],
              ["2 December", "Monday", "St Andrew’s Day (substitute day)"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ]

            assert_bank_holiday_table title: "Past bank holidays in Scotland", year: "2012", rows: [
              ["2012"],
              ["30 November", "Friday", "St Andrew’s Day"],
              ["6 August", "Monday", "Summer bank holiday"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday (substitute day)"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["6 April", "Friday", "Good Friday"],
              ["3 January", "Tuesday", "New Year’s Day (substitute day)"],
              ["2 January", "Monday", "2nd January"],
            ]
          end

          within "#northern-ireland" do
            assert page.has_link?("Add bank holidays for Northern Ireland to your calendar", href: "/bank-holidays/northern-ireland.ics")

            assert_bank_holiday_table title: "Upcoming bank holidays in Northern Ireland", year: "2012", rows: [
              ["2012"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ]
            assert_bank_holiday_table title: "Upcoming bank holidays in Northern Ireland", year: "2013", rows: [
              ["2013"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["18 March", "Monday", "St Patrick’s Day (substitute day)"],
              ["29 March", "Friday", "Good Friday"],
              ["1 April", "Monday", "Easter Monday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["12 July", "Friday", "Battle of the Boyne (Orangemen’s Day)"],
              ["26 August", "Monday", "Summer bank holiday"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ]

            assert_bank_holiday_table title: "Past bank holidays in Northern Ireland", year: "2012", rows: [
              ["2012"],
              ["27 August", "Monday", "Summer bank holiday"],
              ["12 July", "Thursday", "Battle of the Boyne (Orangemen’s Day)"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["9 April", "Monday", "Easter Monday"],
              ["6 April", "Friday", "Good Friday"],
              ["19 March", "Monday", "St Patrick’s Day (substitute day)"],
              ["2 January", "Monday", "New Year’s Day (substitute day)"],
            ]
          end
        end # within .tab-content
      end # within article
    end # within #content
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse("2012-01-03")) do
      visit "/bank-holidays"

      within ".tab-content" do

        within "#england-and-wales .highlighted-event" do
          assert page.has_content?("The next bank holiday in England and Wales is")
          assert page.has_content?("6 April")
          assert page.has_content?("Good Friday")
        end

        within "#scotland .highlighted-event" do
          assert page.has_content?("The next bank holiday in Scotland is")
          assert page.has_content?("today")
          assert page.has_content?("New Year’s Day")
        end

        within "#northern-ireland .highlighted-event" do
          assert page.has_content?("The next bank holiday in Northern Ireland is")
          assert page.has_content?("19 March")
          assert page.has_content?("St Patrick’s Day")
        end
      end # within .tab-content
    end # Timecop
  end

  context "showing bunting on bank holidays" do
    should "show bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/bank-holidays"
        assert page.has_css?(".epic-bunting")
        assert page.has_css?("#wrapper.bunted")
      end
    end

    should "not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/bank-holidays"
        assert page.has_no_css?(".epic-bunting")
        assert page.has_no_css?("#wrapper.bunted")
      end
    end

    should "not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/bank-holidays"
        assert page.has_no_css?(".epic-bunting")
        assert page.has_no_css?("#wrapper.bunted")
      end
    end
  end # within #content

  context "last updated" do
    should "be formatted correctly" do
      Timecop.travel(Date.parse("5th Dec 2012")) do
        visit "/bank-holidays"
        within ".meta-data" do
          assert page.has_content?("Last updated: 5 December 2012")
        end
      end
    end
  end
end
