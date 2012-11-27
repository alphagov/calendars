# encoding: utf-8
require_relative '../integration_test_helper'

class WhenDoTheClocksChangeTest < ActionDispatch::IntegrationTest

  should "display the clocks change page" do

    visit "/when-do-the-clocks-change"

    within 'head' do
      assert page.has_selector?("title", :text => "When do the clocks change? - GOV.UK")
      desc = page.find("meta[name=description]")
      assert_equal "In the UK the clocks go forward 1 hour at 1am on the last Sunday in March, and back 1 hour at 2am on the last Sunday in October.", desc["content"]

      #assert page.has_selector?("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change/united-kingdom.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/when-do-the-clocks-change/united-kingdom.ics']")
    end

    within "#content" do
      within 'header' do
        assert page.has_content?("When do the clocks change?")
        assert page.has_content?("Quick answer")
      end

      within 'article' do
        rows = page.all('table.clocks-calendar tr').map {|row| row.all('th,td').map(&:text) }
        assert_equal [
          ["Year", "Clocks go forward", "Clocks go back"],
          ["2012", "25 March", "28 October"],
          ["2013", "31 March", "27 October"],
          ["2014", "30 March", "26 October"],
        ], rows

        assert page.has_link?("Clock changes in the UK", :href => "/when-do-the-clocks-change/united-kingdom.ics")
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
