# encoding: utf-8
require_relative '../integration_test_helper'

class BankHolidaysTest < ActionDispatch::IntegrationTest

  should "display the bank holidays page" do

    visit "/bank-holidays"

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

          within '#ni' do
            assert page.has_table?("2012 bank holidays in Northern Ireland", :rows => [
              ["02 January", "Monday", "New Year’s Day", "Substitute day"],
              ["19 March", "Monday", "St Patrick’s Day", "Substitute day"],
              ["04 June", "Monday", "Spring bank holiday", ""],
              ["05 June", "Tuesday", "Queen’s Diamond Jubilee", "Extra bank holiday"],
              ["27 August", "Monday", "Summer bank holiday", ""],
              ["25 December", "Tuesday", "Christmas Day", ""],
              ["26 December", "Wednesday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2012 in Northern Ireland", :href => "/bank-holidays/ni-2012.ics")

            assert page.has_table?("2013 bank holidays in Northern Ireland", :rows => [
              ["01 January", "Tuesday", "New Year’s Day", ""],
              ["29 March", "Friday", "Good Friday", ""],
              ["12 July", "Friday", "Battle of the Boyne (Orangemen’s Day)", ""],
              ["25 December", "Wednesday", "Christmas Day", ""],
              ["26 December", "Thursday", "Boxing Day", ""],
            ])
            assert page.has_link?("Bank holidays for 2013 in Northern Ireland", :href => "/bank-holidays/ni-2013.ics")
          end
        end

      end
    end

  end

end
