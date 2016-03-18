# encoding: utf-8
require_relative '../integration_test_helper'

class WhenDoTheClocksChangeTest < ActionDispatch::IntegrationTest

  should "display the clocks change page" do

    visit "/when-do-the-clocks-change"

    within("head", visible: false) do
      assert page.has_selector?("title", :text => "When do the clocks change? - GOV.UK", visible: false)
      desc = page.find("meta[name=description]", visible: false)
      assert_equal "Dates when the clocks go back or forward in 2012, 2013, 2014 - includes British Summer Time, Greenwich Mean Time", desc["content"]

      #assert page.has_selector?("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change/united-kingdom.json']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/when-do-the-clocks-change/united-kingdom.ics']", visible: false)
    end

    within "#content" do
      within 'header' do
        assert page.has_content?("When do the clocks change?")
      end

      within 'article' do
        rows = page.all('table.clocks-calendar tr').map {|row| row.all('th,td').map(&:text) }
        assert_equal [
          ["Year", "Clocks go forward", "Clocks go back"],
          ["2012", "25 March", "28 October"],
          ["2013", "31 March", "27 October"],
          ["2014", "30 March", "26 October"],
        ], rows

        assert page.has_link?("Add clock changes in the UK to your calendar (ICS, 5KB)", :href => "/when-do-the-clocks-change/united-kingdom.ics")
      end
    end
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse('2012-11-15')) do
      visit "/when-do-the-clocks-change"

      within ".highlighted-event" do
        assert page.has_content?("The clocks advance")
        assert page.has_content?("31 March")
      end
    end # Timecop

    Timecop.travel(Date.parse('2013-04-01')) do
      visit "/when-do-the-clocks-change"

      within ".highlighted-event" do
        assert page.has_content?("The clocks go back")
        assert page.has_content?("27 October")
      end
    end # Timecop
  end
end
