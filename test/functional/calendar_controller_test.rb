require_relative '../test_helper'
require 'gds_api/test_helpers/content_api'

class CalendarControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentApi

  context "GET 'index'" do
    setup do
      stub_content_api_default_artefact
    end

    should "send analytics headers" do
      get :index, :scope => "bank-holidays"

      assert_equal 'calendar', @response.headers["X-Slimmer-Format"]
    end

    should "send artefact from panopticon to slimmer" do
      artefact_data = artefact_for_slug('bank-holidays')
      content_api_has_an_artefact('bank-holidays', artefact_data)

      get :index, :scope => "bank-holidays"

      assert_equal artefact_data.to_json, @response.headers[Slimmer::Headers::ARTEFACT_HEADER]
    end
  end

  context "GET 'calendar'" do
    setup do
      stub_content_api_default_artefact
      Calendar.stubs(:find).returns(Calendar.new('something', {"divisions" => []}))
    end

    context "HTML request (no format)" do
      should "load the calendar and assign it to @calendar" do
        @controller.stubs(:render)
        Calendar.expects(:find).with('bank-holidays').returns(:a_calendar)

        get :calendar, :scope => 'bank-holidays'
        assert_equal :a_calendar, assigns[:calendar]
      end

      should "render the template corresponding to the given calendar" do
        get :calendar, :scope => 'bank-holidays'

        assert_template 'bank_holidays'
      end

      should "set the expiry headers" do
        get :calendar, :scope => 'bank-holidays'
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end

      should "send analytics headers" do
        get :calendar, :scope => 'bank-holidays'

        assert_equal 'calendar', @response.headers["X-Slimmer-Format"]
      end

      should "send artefact from content_api to slimmer" do
        artefact_data = artefact_for_slug('bank-holidays')
        content_api_has_an_artefact('bank-holidays', artefact_data)

        get :calendar, :scope => 'bank-holidays'

        assert_equal artefact_data.to_json, @response.headers[Slimmer::Headers::ARTEFACT_HEADER]
      end
    end

    context "json request" do
      should "load the calendar and return its json representation" do
        Calendar.expects(:find).with('bank-holidays').returns(mock("Calendar", :to_json => 'json_calendar'))

        get :calendar, :scope => 'bank-holidays', :format => :json

        assert_equal "json_calendar", response.body
      end

      should "set the expiry headers" do
        get :calendar, :scope => 'bank-holidays', :format => :json
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end
    end

    should "404 for a non-existent calendar" do
      Calendar.stubs(:find).raises(Calendar::CalendarNotFound)

      get :calendar, :scope => 'something'
      assert_equal 404, response.status
    end

    should "404 without looking up the calendar with an invalid slug format" do
      Calendar.expects(:find).never

      get :calendar, :scope => 'something..etc-passwd'
      assert_equal 404, response.status
    end
  end
end
