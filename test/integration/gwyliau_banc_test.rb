# encoding: utf-8
require_relative '../integration_test_helper'

class GwyliauBancTest < ActionDispatch::IntegrationTest

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
              ["02 January", "Monday", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 June", "Monday", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 June", "Tuesday", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 August", "Monday", "Gŵyl Banc yr Haf", ""],
              ["25 December", "Tuesday", "Dydd Nadolig", ""],
              ["26 December", "Wednesday", "Gŵyl San Steffan", ""]
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Cymru a Lloegr", :href => "/gwyliau-banc/england-and-wales-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Cymru a Lloegr", :rows => [
              ["01 January", "Tuesday", "Dydd Calan", ""],
              ["29 March", "Friday", "Dydd Gwener y Groglith", ""],
              ["25 December", "Wednesday", "Dydd Nadolig", ""],
              ["26 December", "Thursday", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Cymru a Lloegr", :href => "/gwyliau-banc/england-and-wales-2013.ics")
          end

          within '#scotland' do
            assert page.has_table?("Gwyliau banc 2012 yng Yr Alban", :rows => [
              ["02 January", "Monday", "2il Ionawr", ""],
              ["03 January", "Tuesday", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 June", "Monday", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 June", "Tuesday", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["06 August", "Monday", "Gŵyl Banc yr Haf", ""],
              ["25 December", "Tuesday", "Dydd Nadolig", ""],
              ["26 December", "Wednesday", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Yr Alban", :href => "/gwyliau-banc/scotland-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Yr Alban", :rows => [
              ["01 January", "Tuesday", "Dydd Calan", ""],
              ["29 March", "Friday", "Dydd Gwener y Groglith", ""],
              ["02 December", "Monday", "Gŵyl Andreas", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["25 December", "Wednesday", "Dydd Nadolig", ""],
              ["26 December", "Thursday", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Yr Alban", :href => "/gwyliau-banc/scotland-2013.ics")
          end

          within '#northern-ireland' do
            assert page.has_table?("Gwyliau banc 2012 yng Gogledd Iwerddon", :rows => [
              ["02 January", "Monday", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["19 March", "Monday", "Gŵyl San Padrig", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 June", "Monday", "Gŵyl Banc y Gwanwyn", ""],
              ["05 June", "Tuesday", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 August", "Monday", "Gŵyl Banc yr Haf", ""],
              ["25 December", "Tuesday", "Dydd Nadolig", ""],
              ["26 December", "Wednesday", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Gogledd Iwerddon", :href => "/gwyliau-banc/northern-ireland-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Gogledd Iwerddon", :rows => [
              ["01 January", "Tuesday", "Dydd Calan", ""],
              ["29 March", "Friday", "Dydd Gwener y Groglith", ""],
              ["12 July", "Friday", "Brwydr y Boyne (Diwrnod yr Orangemen)", ""],
              ["25 December", "Wednesday", "Dydd Nadolig", ""],
              ["26 December", "Thursday", "Gŵyl San Steffan", ""],
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
          assert page.has_content?("4 June")
        end

        within '#scotland .highlighted-event' do
          assert page.has_content?("Dydd Calan")
          assert page.has_content?("today")
        end

        within '#northern-ireland .highlighted-event' do
          assert page.has_content?("Gŵyl San Padrig")
          assert page.has_content?("19 March")
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
