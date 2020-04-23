# encoding: utf-8

RSpec.feature "json" do
  context "GET /calendars/<calendar>.json" do
    it "contains calendar with division" do
      visit "/bank-holidays/england-and-wales.json"

      expected = {
        "division" => "england-and-wales",
        "events" => [
          { "date" => "2012-01-02", "notes" => "Substitute day", "title" => "New Year’s Day", "bunting" => true },
          { "date" => "2012-06-04", "notes" => "Substitute day", "title" => "Spring bank holiday", "bunting" => true },
          { "date" => "2012-06-05", "notes" => "Extra bank holiday", "title" => "Queen’s Diamond Jubilee", "bunting" => true },
          { "date" => "2012-08-27", "notes" => "", "title" => "Summer bank holiday", "bunting" => true },
          { "date" => "2012-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
          { "date" => "2012-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
          { "date" => "2013-01-01", "notes" => "", "title" => "New Year’s Day", "bunting" => true },
          { "date" => "2013-03-29", "notes" => "", "title" => "Good Friday", "bunting" => false },
          { "date" => "2013-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
          { "date" => "2013-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
        ],
      }

      actual = JSON.parse(page.body)
      expect(expected["events"] - actual["events"]).to be_empty
      expect(actual["division"]).to eq(expected["division"])
    end

    it "has the full calendar json view" do
      visit "/bank-holidays.json"

      expected = {
        "england-and-wales" => {
          "division" => "england-and-wales",
          "events" => [
            { "date" => "2012-01-02", "notes" => "Substitute day", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2012-06-04", "notes" => "Substitute day", "title" => "Spring bank holiday", "bunting" => true },
            { "date" => "2012-06-05", "notes" => "Extra bank holiday", "title" => "Queen’s Diamond Jubilee", "bunting" => true },
            { "date" => "2012-08-27", "notes" => "", "title" => "Summer bank holiday", "bunting" => true },
            { "date" => "2012-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2012-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
            { "date" => "2013-01-01", "notes" => "", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2013-03-29", "notes" => "", "title" => "Good Friday", "bunting" => false },
            { "date" => "2013-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2013-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
          ],
        },
        "scotland" => {
          "division" => "scotland",
          "events" => [
            { "date" => "2012-01-02", "notes" => "", "title" => "2nd January", "bunting" => true },
            { "date" => "2012-01-03", "notes" => "Substitute day", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2012-06-04", "notes" => "Substitute day", "title" => "Spring bank holiday", "bunting" => true },
            { "date" => "2012-06-05", "notes" => "Extra bank holiday", "title" => "Queen’s Diamond Jubilee", "bunting" => true },
            { "date" => "2012-08-06", "notes" => "", "title" => "Summer bank holiday", "bunting" => true },
            { "date" => "2012-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2012-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
            { "date" => "2013-01-01", "notes" => "", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2013-03-29", "notes" => "", "title" => "Good Friday", "bunting" => false },
            { "date" => "2013-12-02", "notes" => "Substitute day", "title" => "St Andrew’s Day", "bunting" => true },
            { "date" => "2013-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2013-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
          ],
        },
        "northern-ireland" => {
          "division" => "northern-ireland",
          "events" => [
            { "date" => "2012-01-02", "notes" => "Substitute day", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2012-03-19", "notes" => "Substitute day", "title" => "St Patrick’s Day", "bunting" => true },
            { "date" => "2012-06-04", "notes" => "", "title" => "Spring bank holiday", "bunting" => true },
            { "date" => "2012-06-05", "notes" => "Extra bank holiday", "title" => "Queen’s Diamond Jubilee", "bunting" => true },
            { "date" => "2012-08-27", "notes" => "", "title" => "Summer bank holiday", "bunting" => true },
            { "date" => "2012-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2012-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
            { "date" => "2013-01-01", "notes" => "", "title" => "New Year’s Day", "bunting" => true },
            { "date" => "2013-03-29", "notes" => "", "title" => "Good Friday", "bunting" => false },
            { "date" => "2013-07-12", "notes" => "", "title" => "Battle of the Boyne (Orangemen’s Day)", "bunting" => false },
            { "date" => "2013-12-25", "notes" => "", "title" => "Christmas Day", "bunting" => true },
            { "date" => "2013-12-26", "notes" => "", "title" => "Boxing Day", "bunting" => true },
          ],
        },
      }
      actual = JSON.parse(page.body)
      expected.each do |nation, expected_bank_holidays|
        actual_bank_holidays = actual.fetch(nation)
        expect(expected_bank_holidays["events"] - actual_bank_holidays["events"]).to be_empty
        expect(actual_bank_holidays["division"]).to eq(expected_bank_holidays["division"])
      end
    end

    it "redirects for old 'ni' division" do
      visit "/bank-holidays/ni.json"
      expect(page.current_url).to eq("http://www.example.com/bank-holidays/northern-ireland.json")
    end
  end
end
