# encoding: utf-8

RSpec.feature "When do the clocks change?" do
  before do
    stub_content_store_has_item("/when-do-the-clocks-change")
  end

  it "displays the clocks change page" do
    visit "/when-do-the-clocks-change"

    within("head", visible: false) do
      expect(page).to have_selector("title", text: "When do the clocks change? - GOV.UK", visible: false)
      desc = page.find("meta[name=description]", visible: false)
      expect(desc["content"]).to eq("Dates when the clocks go back or forward in 2012, 2013, 2014 - includes British Summer Time, Greenwich Mean Time")

      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change/united-kingdom.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/when-do-the-clocks-change/united-kingdom.ics']", visible: false)
    end

    within "#content" do
      within ".gem-c-title" do
        expect(page).to have_content("When do the clocks change?")
      end

      within "article" do
        rows = page.all(".app-c-calendar--clocks tr").map { |row| row.all("th,td").map(&:text) }
        expect(rows).to eq([
          ["Year", "Clocks go forward", "Clocks go back"],
          ["2012", "25 March", "28 October"],
          ["2013", "31 March", "27 October"],
          ["2014", "30 March", "26 October"],
        ])

        expect(page).to have_link("Add clock changes in the UK to your calendar (ICS, 2KB)", href: "/when-do-the-clocks-change/united-kingdom.ics")
      end
    end
  end

  it "displays the correct upcoming event" do
    Timecop.travel(Date.parse("2012-11-15")) do
      visit "/when-do-the-clocks-change"

      within ".govuk-panel" do
        expect(page).to have_content("The clocks advance")
        expect(page).to have_content("31 March")
      end
    end

    Timecop.travel(Date.parse("2013-04-01")) do
      visit "/when-do-the-clocks-change"

      within ".govuk-panel" do
        expect(page).to have_content("The clocks go back")
        expect(page).to have_content("27 October")
      end
    end
  end
end
