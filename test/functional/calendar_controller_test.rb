require_relative '../test_helper'
require 'gds_api/test_helpers/content_api'

class CalendarControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentApi

  context "GET 'calendar'" do
    setup do
      stub_content_api_default_artefact
      Calendar.stubs(:find).returns(Calendar.new('something', "divisions" => []))
    end

    context "HTML request (no format)" do
      should "load the calendar and assign it to @calendar" do
        @controller.stubs(:render)
        Calendar.expects(:find).with('bank-holidays').returns(:a_calendar)

        get :calendar, scope: 'bank-holidays'
        assert_equal :a_calendar, assigns[:calendar]
      end

      should "render the template corresponding to the given calendar" do
        get :calendar, scope: 'bank-holidays'

        assert_template 'bank_holidays'
      end

      should "set the expiry headers" do
        get :calendar, scope: 'bank-holidays'
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end

      should "send analytics headers" do
        get :calendar, scope: 'bank-holidays'

        assert_equal 'calendar', @response.headers["X-Slimmer-Format"]
      end

      should "send artefact from content_api to slimmer" do
        artefact_data = artefact_for_slug('bank-holidays')
        content_api_has_an_artefact('bank-holidays', artefact_data)

        get :calendar, scope: 'bank-holidays'

        assert_equal artefact_data.to_json, @response.headers[Slimmer::Headers::ARTEFACT_HEADER]
      end

      should "503 if fetching the arterfact times out" do
        stub_request(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}}).to_timeout
        get :calendar, scope: 'bank-holidays'
        assert_equal 503, response.status
      end
    end

    context "for a welsh language artefact" do
      should "set the I18n locale" do
        artefact_data = artefact_for_slug('gwyliau-banc')
        artefact_data["details"].merge!(language: "cy")
        content_api_has_an_artefact('gwyliau-banc', artefact_data)
        get :calendar, scope: 'gwyliau-banc'
        assert_equal :cy, I18n.locale
      end
    end

    context "json request" do
      should "load the calendar and return its json representation" do
        Calendar.expects(:find).with('bank-holidays').returns(mock("Calendar", to_json: 'json_calendar'))

        get :calendar, scope: 'bank-holidays', format: :json

        assert_equal "json_calendar", response.body
      end

      should "set the expiry headers" do
        get :calendar, scope: 'bank-holidays', format: :json
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end

      should "set the CORS headers" do
        get :calendar, scope: 'bank-holidays', format: :json

        assert_equal "*", response.headers['Access-Control-Allow-Origin']
      end
    end

    should "404 for a non-existent calendar" do
      Calendar.stubs(:find).raises(Calendar::CalendarNotFound)

      get :calendar, scope: 'something'
      assert_equal 404, response.status
    end

    should "404 without looking up the calendar with an invalid slug format" do
      Calendar.expects(:find).never

      get :calendar, scope: 'something..etc-passwd'
      assert_equal 404, response.status
    end
  end

  context "GET 'division'" do
    setup do
      stub_content_api_default_artefact
      @division = stub("Division", to_json: "", events: [])
      @calendar = stub("Calendar")
      @calendar.stubs(:division).returns(@division)
      Calendar.stubs(:find).returns(@calendar)
    end

    should "return the json representation of the division" do
      @division.expects(:to_json).returns("json_division")
      @calendar.expects(:division).with('a-division').returns(@division)
      Calendar.expects(:find).with('a-calendar').returns(@calendar)

      get :division, scope: "a-calendar", division: "a-division", format: "json"
      assert_equal "json_division", @response.body
    end

    should "return the ics representation of the division" do
      @division.expects(:events).returns(:some_events)
      @calendar.expects(:division).with('a-division').returns(@division)
      Calendar.expects(:find).with('a-calendar').returns(@calendar)
      ICSRenderer.expects(:new).with(:some_events, "/a-calendar/a-division.ics").returns(mock("Renderer", render: "ics_division"))

      get :division, scope: "a-calendar", division: "a-division", format: "ics"
      assert_equal "ics_division", @response.body
    end

    should "set the expiry headers" do
      get :division, scope: "a-calendar", division: "a-division", format: "ics"
      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "404 for a html request" do
      get :division, scope: "a-calendar", division: "a-division", format: "html"
      assert_equal 404, @response.status

      get :division, scope: "a-calendar", division: "a-division"
      assert_equal 404, @response.status
    end

    should "404 with an invalid division" do
      @calendar.stubs(:division).raises(Calendar::CalendarNotFound)

      get :division, scope: 'something', division: 'foo', format: "json"
      assert_equal 404, response.status
    end

    should "404 for a non-existent calendar" do
      Calendar.stubs(:find).raises(Calendar::CalendarNotFound)

      get :division, scope: 'something', division: 'foo', format: "json"
      assert_equal 404, response.status
    end

    should "404 without looking up the calendar with an invalid slug format" do
      Calendar.expects(:find).never

      get :division, scope: 'something..etc-passwd', division: 'foo', format: "json"
      assert_equal 404, response.status
    end
  end
end
