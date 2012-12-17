require_relative 'test_helper'
require 'capybara/rails'
require 'gds_api/test_helpers/content_api'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::ContentApi

  setup do
    stub_content_api_default_artefact
  end

  def assert_table_with_caption(caption, attrs = {})
    table = page.all(:xpath, ".//table[caption='#{caption}']").first
    assert table, "Failed to find table with caption #{caption}"
    if attrs[:rows]
      actual_rows = table.all('tr').map {|r| r.all('th, td').map(&:text).map(&:strip) }
      assert_equal attrs[:rows], actual_rows
    end
  end
end
