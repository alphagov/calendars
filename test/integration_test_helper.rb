require_relative "test_helper"
require "capybara/rails"
require "gds_api/test_helpers/content_api"

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::ContentApi

  setup do
    stub_content_api_default_artefact
    I18n.locale = :en
  end

  def assert_bank_holiday_table(attrs)
    header = page.find("h2", text: attrs[:title])
    table = page.find(:xpath, ".//table[.//*[@aria-labelledby='#{header["id"]}'][text()='#{attrs[:year]}']]")
    if attrs[:rows]
      actual_rows = table.all("tr").map {|r| r.all("th, td").map(&:text).map(&:strip) }
      assert_equal attrs[:rows], actual_rows
    end
  end
end
