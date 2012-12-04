# encoding: utf-8
require_relative '../integration_test_helper'

class GwyliauBancTest < ActionDispatch::IntegrationTest

  setup do
    artefact_data = artefact_for_slug('gwyliau-banc')
    artefact_data.merge!(language: :cy)
    content_api_has_an_artefact('gwyliau-banc', artefact_data)   
  end

  should "display the Gwyliau Banc page (Bank Holidays page in Welsh)" do

    visit "/gwyliau-banc"

    within 'head' do
      assert page.has_selector?("title", :text => "Gwyliau banc y DU - GOV.UK")
      desc = page.find("meta[name=description]")
      assert_equal "Calendr gwyliau banc y DU – edrychwch ar wyliau banc a gwyliau cyhoeddus y DU ar gyfer 2012 a 2013", desc["content"]

      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/england-and-wales.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/england-and-wales.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/scotland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/scotland.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/northern-ireland.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/northern-ireland.ics']")
    end

    within "#content" do
      within 'header' do
        assert page.has_content?("Gwyliau banc y DU")
        assert page.has_content?("Ateb cyflym")
      end

      within 'article' do
        within '.nav-tabs' do
          tab_labels = page.all("ul li a").map(&:text)
          assert_equal ['Cymru a Lloegr', 'Yr Alban', 'Gogledd Iwerddon'], tab_labels
        end

        within '.tab-content' do
          within '#england-and-wales' do
            assert page.has_table?("Gwyliau banc 2012 yng Cymru a Lloegr", :rows => [
              ["02 Ionawr", "Dydd Llun", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""]
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Cymru a Lloegr", :href => "/gwyliau-banc/england-and-wales-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Cymru a Lloegr", :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Cymru a Lloegr", :href => "/gwyliau-banc/england-and-wales-2013.ics")
          end

          within '#scotland' do
            assert page.has_table?("Gwyliau banc 2012 yng Yr Alban", :rows => [
              ["02 Ionawr", "Dydd Llun", "2il Ionawr", ""],
              ["03 Ionawr", "Dydd Mawrth", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["06 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Yr Alban", :href => "/gwyliau-banc/scotland-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Yr Alban", :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["02 Rhagfyr", "Dydd Llun", "Gŵyl Andreas", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Yr Alban", :href => "/gwyliau-banc/scotland-2013.ics")
          end

          within '#northern-ireland' do
            assert page.has_table?("Gwyliau banc 2012 yng Gogledd Iwerddon", :rows => [
              ["02 Ionawr", "Dydd Llun", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["19 Mawrth", "Dydd Llun", "Gŵyl San Padrig", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", ""],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Gogledd Iwerddon", :href => "/gwyliau-banc/northern-ireland-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Gogledd Iwerddon", :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["12 Gorffennaf", "Dydd Gwener", "Brwydr y Boyne (Diwrnod yr Orangemen)", ""],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Gogledd Iwerddon", :href => "/gwyliau-banc/northern-ireland-2013.ics")
          end
        end # within .tab-content
      end # within article
    end # within #content
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse('2012-01-03')) do
      visit "/gwyliau-banc"

      within ".tab-content" do

        within '#england-and-wales .highlighted-event' do
          assert page.has_content?("Gŵyl Banc y Gwanwyn")
          assert page.has_content?("4 Mehefin")
        end

        within '#scotland .highlighted-event' do
          assert page.has_content?("Dydd Calan")
          assert page.has_content?("heddiw")
        end

        within '#northern-ireland .highlighted-event' do
          assert page.has_content?("Gŵyl San Padrig")
          assert page.has_content?("19 Mawrth")
        end
      end # within .tab-content
    end # Timecop
  end

  context "showing bunting on bank holidays" do
    should "show bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/gwyliau-banc"
        assert page.has_css?('.epic-bunting')
      end
    end

    should "not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.epic-bunting')
      end
    end

    should "not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.epic-bunting')
      end
    end
  end
end
