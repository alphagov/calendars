# encoding: utf-8
require_relative '../integration_test_helper'

class WhenDoTheClocksChangeTest < ActionDispatch::IntegrationTest

  should "display the bank holidays page" do

    visit "/when-do-the-clocks-change"

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