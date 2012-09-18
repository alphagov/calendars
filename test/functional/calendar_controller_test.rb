require 'test_helper'
require 'gds_api/test_helpers/content_api'

class CalendarControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentApi

  context "GET 'index'" do
    setup do
      stub_content_api_default_artefact
    end

    should "send analytics headers" do
      get :index, :scope => "bank-holidays"

      assert_equal "Life in the UK".downcase,  @response.headers["X-Slimmer-Section"].downcase
      assert_equal "121",             @response.headers["X-Slimmer-Need-ID"].to_s
      assert @response.headers["X-Slimmer-Format"].present?
      assert_equal "citizen",         @response.headers["X-Slimmer-Proposition"]
    end

    should "send artefact from panopticon to slimmer" do
      artefact_data = artefact_for_slug('bank-holidays')
      content_api_has_an_artefact('bank-holidays', artefact_data)

      get :index, :scope => "bank-holidays"

      assert_equal artefact_data.to_json, @response.headers[Slimmer::Headers::ARTEFACT_HEADER]
    end
  end
end
