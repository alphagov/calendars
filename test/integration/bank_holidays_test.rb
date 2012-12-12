# encoding: utf-8
require_relative '../integration_test_helper'

class BankHolidaysTest < ActionDispatch::IntegrationTest

  should "display the bank holidays page" do

    visit "/bank-holidays"

    within 'head' do
      assert page.has_selector?("title", :text => "UK bank holidays - GOV.UK")
      desc = page.find("meta[name=description]")
      assert_equal "UK bank holidays calendar - see UK bank holidays and public holidays for 2012 and 2013", desc["content"]

      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/england-and-wales.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/england-and-wales.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/scotland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/scotland.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/bank-holidays/northern-ireland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/bank-holidays/northern-ireland.ics']")
    end

    within "#content" do
      within 'header' do
        assert page.has_content?("UK bank holidays")
        assert page.has_content?("Quick answer")
      end

      within 'article' do
        within '.nav-tabs' do
          tab_labels = page.all("ul li a").map(&:text)
          assert_equal ['England and Wales', 'Scotland', 'Northern Ireland'], tab_labels
        end

        within '.tab-content' do
          within '#england-and-wales' do
            assert page.has_table?("2012 bank holidays in England and Wales", :rows => [
              ["02 January", "Monday", "New Year’s Day", "Substitute day"],
              ["04 June", "Monday", "Spring bank holiday", "Substitute day"],
              ["05 June", "Tuesday", "Queen’s Diamond Jubilee", "Extra bank holiday"],
              ["27 August", "Monday", "Summer bank holiday", ""],
              ["25 December", "Tuesday", "Christmas Day", ""],
              ["26 December", "Wednesday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2012 in England and Wales", :href => "/bank-holidays/england-and-wales-2012.ics")

            assert page.has_table?("2013 bank holidays in England and Wales", :rows => [
              ["01 January", "Tuesday", "New Year’s Day", ""],
              ["29 March", "Friday", "Good Friday", ""],
              ["25 December", "Wednesday", "Christmas Day", ""],
              ["26 December", "Thursday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2013 in England and Wales", :href => "/bank-holidays/england-and-wales-2013.ics")
          end

          within '#scotland' do
            assert page.has_table?("2012 bank holidays in Scotland", :rows => [
              ["02 January", "Monday", "2nd January", ""],
              ["03 January", "Tuesday", "New Year’s Day", "Substitute day"],
              ["04 June", "Monday", "Spring bank holiday", "Substitute day"],
              ["05 June", "Tuesday", "Queen’s Diamond Jubilee", "Extra bank holiday"],
              ["06 August", "Monday", "Summer bank holiday", ""],
              ["25 December", "Tuesday", "Christmas Day", ""],
              ["26 December", "Wednesday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2012 in Scotland", :href => "/bank-holidays/scotland-2012.ics")

            assert page.has_table?("2013 bank holidays in Scotland", :rows => [
              ["01 January", "Tuesday", "New Year’s Day", ""],
              ["29 March", "Friday", "Good Friday", ""],
              ["02 December", "Monday", "St Andrew’s Day", "Substitute day"],
              ["25 December", "Wednesday", "Christmas Day", ""],
              ["26 December", "Thursday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2013 in Scotland", :href => "/bank-holidays/scotland-2013.ics")
          end

          within '#northern-ireland' do
            assert page.has_table?("2012 bank holidays in Northern Ireland", :rows => [
              ["02 January", "Monday", "New Year’s Day", "Substitute day"],
              ["19 March", "Monday", "St Patrick’s Day", "Substitute day"],
              ["04 June", "Monday", "Spring bank holiday", ""],
              ["05 June", "Tuesday", "Queen’s Diamond Jubilee", "Extra bank holiday"],
              ["27 August", "Monday", "Summer bank holiday", ""],
              ["25 December", "Tuesday", "Christmas Day", ""],
              ["26 December", "Wednesday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2012 in Northern Ireland", :href => "/bank-holidays/northern-ireland-2012.ics")

            assert page.has_table?("2013 bank holidays in Northern Ireland", :rows => [
              ["01 January", "Tuesday", "New Year’s Day", ""],
              ["29 March", "Friday", "Good Friday", ""],
              ["12 July", "Friday", "Battle of the Boyne (Orangemen’s Day)", ""],
              ["25 December", "Wednesday", "Christmas Day", ""],
              ["26 December", "Thursday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2013 in Northern Ireland", :href => "/bank-holidays/northern-ireland-2013.ics")
          end
        end # within .tab-content
      end # within article
    end # within #content
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse('2012-01-03')) do
      visit "/bank-holidays"

      within ".tab-content" do

        within '#england-and-wales .highlighted-event' do
          assert page.has_content?("Spring bank holiday")
          assert page.has_content?("4 June")
        end

        within '#scotland .highlighted-event' do
          assert page.has_content?("New Year’s Day")
          assert page.has_content?("today")
        end

        within '#northern-ireland .highlighted-event' do
          assert page.has_content?("St Patrick’s Day")
          assert page.has_content?("19 March")
        end
      end # within .tab-content
    end # Timecop
  end

  context "showing bunting on bank holidays" do
    should "show bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/bank-holidays"
        assert page.has_css?('.epic-bunting')
      end
    end

    should "not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/bank-holidays"
        assert page.has_no_css?('.epic-bunting')
      end
    end

    should "not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/bank-holidays"
        assert page.has_no_css?('.epic-bunting')
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
