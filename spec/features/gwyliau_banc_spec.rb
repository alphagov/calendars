# encoding: utf-8

RSpec.feature "Gwyliau banc" do
  before do
    content_item = content_item_for_base_path("/bank-holidays")
    content_item["locale"] = "cy"
    stub_content_store_has_item("/bank-holidays", content_item)
  end

  it "displays the Gwyliau Banc page" do
    Timecop.travel("2012-12-14")

    visit "/gwyliau-banc"

    within("head", visible: false) do
      expect(page).to have_selector("title", text: "Gwyliau banc y DU - GOV.UK", visible: false)
      desc = page.find("meta[name=description]", visible: false)
      expect(desc["content"]).to eq("Calendr gwyliau banc y DU - edrychwch ar wyliau banc a gwyliau cyhoeddus y DU")

      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/cymru-a-lloegr.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/cymru-a-lloegr.ics']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/yr-alban.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/yr-alban.ics']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/gogledd-iwerddon.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/gogledd-iwerddon.ics']", visible: false)
    end

    within "#content" do
      within ".gem-c-title" do
        expect(page).to have_content("Gwyliau banc y DU")
      end

      within "article" do
        within ".govuk-tabs" do
          tab_labels = page.all("ul li a").map(&:text)
          expect(tab_labels).to eq(["Cymru a Lloegr", "Yr Alban", "Gogledd Iwerddon"])
        end

        within ".govuk-tabs" do
          within "#cymru-a-lloegr" do
            expect(page).to have_link("Ychwanegwch ddyddiadau gwyliau banc yng Nghymru a Lloegr at eich calendr", href: "/gwyliau-banc/cymru-a-lloegr.ics")

            assert_bank_holiday_table title: "Gwyliau banc i ddod yng Nghymru a Lloegr", year: "2012", rows: [
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan"],
            ]
            assert_bank_holiday_table title: "Gwyliau banc i ddod yng Nghymru a Lloegr", year: "2013", rows: [
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["1 Ebrill", "Dydd Llun", "Dydd Llun y Pasg"],
              ["6 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl Banc y Gwanwyn"],
              ["26 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan"],
            ]

            assert_bank_holiday_table title: "Gwyliau banc yn y gorffennol yng Nghymru a Lloegr", year: "2012", rows: [
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["5 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["7 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["9 Ebrill", "Dydd Llun", "Dydd Llun y Pasg"],
              ["6 Ebrill", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["2 Ionawr", "Dydd Llun", "Dydd Calan (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
            ]
          end

          within "#yr-alban" do
            expect(page).to have_link("Ychwanegwch ddyddiadau gwyliau banc yn yr Alban at eich calendr", href: "/gwyliau-banc/yr-alban.ics")

            assert_bank_holiday_table title: "Gwyliau banc i ddod yn yr Alban", year: "2012", rows: [
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan"],
            ]
            assert_bank_holiday_table title: "Gwyliau banc i ddod yn yr Alban", year: "2013", rows: [
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["2 Ionawr", "Dydd Mercher", "2il Ionawr"],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["6 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl Banc y Gwanwyn"],
              ["5 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["2 Rhagfyr", "Dydd Llun", "Gŵyl Andreas (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan"],
            ]

            assert_bank_holiday_table title: "Gwyliau banc yn y gorffennol yn yr Alban", year: "2012", rows: [
              ["30 Tachwedd", "Dydd Gwener", "Gŵyl Andreas"],
              ["6 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["5 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["7 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["6 Ebrill", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["3 Ionawr", "Dydd Mawrth", "Dydd Calan (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["2 Ionawr", "Dydd Llun", "2il Ionawr"],
            ]
          end

          within "#gogledd-iwerddon" do
            expect(page).to have_link("Ychwanegwch ddyddiadau gwyliau banc yng Ngogledd Iwerddon at eich calendr", href: "/gwyliau-banc/gogledd-iwerddon.ics")

            assert_bank_holiday_table title: "Gwyliau banc i ddod yng Ngogledd Iwerddon", year: "2012", rows: [
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan"],
            ]
            assert_bank_holiday_table title: "Gwyliau banc i ddod yng Ngogledd Iwerddon", year: "2013", rows: [
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["18 Mawrth",
               "Dydd Llun",
               "Gŵyl San Padrig (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["1 Ebrill", "Dydd Llun", "Dydd Llun y Pasg"],
              ["6 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl Banc y Gwanwyn"],
              ["12 Gorffennaf", "Dydd Gwener", "Brwydr y Boyne (Diwrnod yr Orangemen)"],
              ["26 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan"],
            ]

            assert_bank_holiday_table title: "Gwyliau banc yn y gorffennol yng Ngogledd Iwerddon", year: "2012", rows: [
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf"],
              ["12 Gorffennaf", "Dydd Iau", "Brwydr y Boyne (Diwrnod yr Orangemen)"],
              ["5 Mehefin",
               "Dydd Mawrth",
               "Jiwbilî Diemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn"],
              ["7 Mai", "Dydd Llun", "Gŵyl Banc Cyntaf Mai"],
              ["9 Ebrill", "Dydd Llun", "Dydd Llun y Pasg"],
              ["6 Ebrill", "Dydd Gwener", "Dydd Gwener y Groglith"],
              ["19 Mawrth", "Dydd Llun", "Gŵyl San Padrig (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
              ["2 Ionawr", "Dydd Llun", "Dydd Calan (diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos)"],
            ]
          end
        end
      end
    end
  end

  it "displays the correct upcoming event" do
    Timecop.travel(Date.parse("2012-01-03")) do
      visit "/gwyliau-banc"

      within ".govuk-tabs" do
        within "#cymru-a-lloegr .govuk-panel" do
          expect(page).to have_content("Y gŵyl banc nesaf yng Nghymru a Lloegr yw")
          expect(page).to have_content("6 Ebrill")
          expect(page).to have_content("Dydd Gwener y Groglith")
        end

        within "#yr-alban .govuk-panel" do
          expect(page).to have_content("Y gŵyl banc nesaf yn yr Alban yw")
          expect(page).to have_content("heddiw")
          expect(page).to have_content("Dydd Calan")
        end

        within "#gogledd-iwerddon .govuk-panel" do
          expect(page).to have_content("Y gŵyl banc nesaf yng Ngogledd Iwerddon yw")
          expect(page).to have_content("19 Mawrth")
          expect(page).to have_content("Gŵyl San Padrig")
        end
      end
    end
  end

  context "showing bunting on bank holidays" do
    it "shows bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/gwyliau-banc"
        expect(page).to have_css(".app-o-epic-bunting")
      end
    end

    it "doesn't show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/gwyliau-banc"
        expect(page).to have_no_css(".app-o-epic-bunting")
      end
    end

    it "doesn't show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/gwyliau-banc"
        expect(page).to have_no_css(".app-o-epic-bunting")
      end
    end
  end

  context "last updated" do
    it "is translated and localised" do
      Timecop.travel(Date.parse("25th Dec 2012")) do
        visit "/gwyliau-banc"
        within ".app-c-meta-data" do
          expect(page).to have_content("Diweddarwyd diwethaf: 25 Rhagfyr 2012")
        end
      end
    end
  end
end
