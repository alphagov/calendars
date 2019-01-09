# encoding: utf-8

require_relative '../integration_test_helper'

class GwyliauBancTest < ActionDispatch::IntegrationTest
  setup do
    content_item = content_item_for_base_path('/bank-holidays')
    content_item["locale"] = "cy"
    content_store_has_item('/bank-holidays', content_item)
  end

  should "display the Gwyliau Banc page" do
    Timecop.travel("2012-12-14")

    visit "/gwyliau-banc"

    within("head", visible: false) do
      assert page.has_selector?("title", text: "Gwyliau banc y DU - GOV.UK", visible: false)
      desc = page.find("meta[name=description]", visible: false)
      assert_equal "Calendr gwyliau banc y DU - edrychwch ar wyliau banc a gwyliau cyhoeddus y DU", desc["content"]

      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc.json']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/cymru-a-lloegr.json']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/cymru-a-lloegr.ics']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/yr-alban.json']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/yr-alban.ics']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/gogledd-iwerddon.json']", visible: false)
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/gogledd-iwerddon.ics']", visible: false)
    end

    within "#content" do
      within '.gem-c-title' do
        assert page.has_content?("Gwyliau banc y DU")
      end

      within 'article' do
        within '.govuk-tabs' do
          tab_labels = page.all("ul li a").map(&:text)
          assert_equal ['Cymru a Lloegr', 'Yr Alban', 'Gogledd Iwerddon'], tab_labels
        end

        within '.govuk-tabs' do
          within '#cymru-a-lloegr' do
            assert page.has_link?("Ychwanegwch ddyddiadau gwyliau banc yng Nghymru a Lloegr at eich calendr", href: "/gwyliau-banc/cymru-a-lloegr.ics")

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

          within '#yr-alban' do
            assert page.has_link?("Ychwanegwch ddyddiadau gwyliau banc yn yr Alban at eich calendr", href: "/gwyliau-banc/yr-alban.ics")

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

          within '#gogledd-iwerddon' do
            assert page.has_link?("Ychwanegwch ddyddiadau gwyliau banc yng Ngogledd Iwerddon at eich calendr", href: "/gwyliau-banc/gogledd-iwerddon.ics")

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
        end # within .govuk-tabs
      end # within article
    end # within #content
  end

  should "show schema.org information about the upcoming bank holidays" do
    Timecop.travel("2012-12-14")

    visit "/gwyliau-banc"

    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }
    event_schemas = schemas.detect do |schema|
      schema.class == Array && schema.all? { |item| item["@type"] == "Event" }
    end

    # Ensure that holidays for each division are present
    ["Gŵyl banc yng Ngogledd Iwerddon", "Gŵyl banc yn yr Alban", "Gŵyl banc yng Nghymru a Lloegr"].each do |description|
      assert event_schemas.detect { |event| event["description"] == description }, "#{description} is missing from the holidays list"
    end

    # Ensure that there are Christmas days in the correct format (one for each division)
    first_events = event_schemas[0...2]
    first_events.each do |event|
      assert_equal event["name"], "Dydd Nadolig"
      assert_equal event["startDate"], "2012-12-25T00:00:00+00:00"
      assert_equal event["endDate"], "2012-12-25T23:59:59+00:00"
      assert_equal event["duration"], "P1D"
      assert_equal event["location"]["@type"], "AdministrativeArea"
    end

    # Ensure that summer bank holidays are displayed with the correct time offset
    summer_date = event_schemas.detect { |event| event["name"] == "Gŵyl Banc yr Haf" }
    assert_equal summer_date["startDate"], "2013-08-05T00:00:00+01:00"
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse('2012-01-03')) do
      visit "/gwyliau-banc"

      within ".govuk-tabs" do
        within '#cymru-a-lloegr .govuk-panel' do
          assert page.has_content?("Y gŵyl banc nesaf yng Nghymru a Lloegr yw")
          assert page.has_content?("6 Ebrill")
          assert page.has_content?("Dydd Gwener y Groglith")
        end

        within '#yr-alban .govuk-panel' do
          assert page.has_content?("Y gŵyl banc nesaf yn yr Alban yw")
          assert page.has_content?("heddiw")
          assert page.has_content?("Dydd Calan")
        end

        within '#gogledd-iwerddon .govuk-panel' do
          assert page.has_content?("Y gŵyl banc nesaf yng Ngogledd Iwerddon yw")
          assert page.has_content?("19 Mawrth")
          assert page.has_content?("Gŵyl San Padrig")
        end
      end # within .govuk-tabs
    end # Timecop
  end

  context "showing bunting on bank holidays" do
    should "show bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/gwyliau-banc"
        assert page.has_css?('.app-o-epic-bunting')
      end
    end

    should "not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.app-o-epic-bunting')
      end
    end

    should "not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.app-o-epic-bunting')
      end
    end
  end

  context "last updated" do
    should "be translated and localised" do
      Timecop.travel(Date.parse("25th Dec 2012")) do
        visit "/gwyliau-banc"
        within ".app-c-meta-data" do
          assert page.has_content?("Diweddarwyd diwethaf: 25 Rhagfyr 2012")
        end
      end
    end
  end
end
