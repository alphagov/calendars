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

end
