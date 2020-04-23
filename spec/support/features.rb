require "capybara/rails"
require "gds_api/test_helpers/content_store"

module FeatureHelpers
  include GdsApi::TestHelpers::ContentStore

  def assert_bank_holiday_table(attrs)
    table = page.find("caption", text: "#{attrs[:title]} #{attrs[:year]}").ancestor("table")
    if attrs[:rows]
      actual_rows = table.all("tr").map { |r| r.all("th, td").map(&:text).map(&:strip) }
      expect(actual_rows).to eq(attrs[:rows])
    end
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
