require 'test_helper'
require 'gds_api/test_helpers/panopticon'

class CalendarControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Panopticon

  context "GET 'index'" do
    setup do
      stub_panopticon_default_artefact
    end

    should "send analytics headers" do
      get :index, :scope => "bank-holidays"

      assert_equal "Life in the UK".downcase,  @response.headers["X-Slimmer-Section"].downcase
      assert_equal "121",             @response.headers["X-Slimmer-Need-ID"].to_s
      assert @response.headers["X-Slimmer-Format"].present?
      assert_equal "citizen",         @response.headers["X-Slimmer-Proposition"]
    end

    should "send artefact from panopticon to slimmer" do
      mock_artefact = {'slug' => 'bank-holidays', "name" => "UK bank holidays"}
      GdsApi::Panopticon.any_instance.expects(:artefact_for_slug).with('bank-holidays').returns(mock_artefact)

      @controller.expects(:set_slimmer_artefact).with(mock_artefact)

      get :index, :scope => "bank-holidays"
    end
  end
end
