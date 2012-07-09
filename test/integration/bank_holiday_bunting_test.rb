require "integration_test_helper"

class BankHolidayBuntingTest < ActionDispatch::IntegrationTest
  should "give a 200 status when hitting the bank-holidays slug" do
    visit "/bank-holidays"
    assert_equal 200, page.status_code
  end

  should "not have bunting if it's not a bank holiday" do
    Timecop.travel(Date.parse("3rd Feb 2012"))
    visit "/bank-holidays"
    assert_equal 200, page.status_code
    assert_equal false, page.has_css?('.epic-bunting')
  end

  should "not have bunting if it's not allowed (Orangemen's Day)" do
    Timecop.travel(Date.parse("12th July 2012"))
    visit "/bank-holidays"
    assert_equal 200, page.status_code
    assert_equal false, page.has_css?('.epic-bunting')
  end

  should "have bunting if set to have bunting allowed" do
    Timecop.travel(Date.parse("2nd Jan 2012"))
    visit "/bank-holidays"
    assert_equal 200, page.status_code
    assert_equal true, page.has_css?('.epic-bunting')
  end
end
