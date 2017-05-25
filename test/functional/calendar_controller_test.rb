require_relative '../test_helper'
require 'gds_api/test_helpers/content_store'

class CalendarControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  context "GET 'calendar'" do
    setup do
      Calendar.stubs(:find).returns(Calendar.new("something", "title" => "Brilliant holidays!", "divisions" => []))
      content_store_has_item('/bank-holidays')
      content_store_has_item('/when-do-the-clocks-change')
    end

    context "HTML request (no format)" do
      should "load the calendar and shows it" do
        get :calendar, params: { scope: 'bank-holidays' }

        assert_match "Brilliant holidays!", response.body
      end

      should "render the template corresponding to the given calendar" do
        get :calendar, params: { scope: 'bank-holidays' }

        assert_template 'bank_holidays'
      end

      should "set the expiry headers" do
        get :calendar, params: { scope: 'bank-holidays' }
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end
    end

    context "for a welsh language content item" do
      should "set the I18n locale" do
        content_item = content_item_for_base_path('/bank-holidays')
        content_item["locale"] = "cy"
        content_store_has_item('/bank-holidays', content_item)
        get :calendar, params: { scope: 'gwyliau-banc', locale: 'cy' }
        assert_equal :cy, I18n.locale
      end
    end

    context "json request" do
      should "load the calendar and return its json representation" do
        Calendar.expects(:find).with('bank-holidays').returns(mock("Calendar", to_json: 'json_calendar'))

        get :calendar, params: { scope: 'bank-holidays', format: :json }

        assert_equal "json_calendar", response.body
      end

      should "set the expiry headers" do
        get :calendar, params: { scope: 'bank-holidays', format: :json }
        assert_equal "max-age=3600, public", response.headers["Cache-Control"]
      end

      should "set the CORS headers" do
        get :calendar, params: { scope: 'bank-holidays', format: :json }

        assert_equal "*", response.headers['Access-Control-Allow-Origin']
      end
    end

    should "404 for a non-existent calendar" do
      Calendar.stubs(:find).raises(Calendar::CalendarNotFound)

      get :calendar, params: { scope: 'something' }
      assert_equal 404, response.status
    end

    should "404 without looking up the calendar with an invalid slug format" do
      Calendar.expects(:find).never

      get :calendar, params: { scope: 'something..etc-passwd' }
      assert_equal 404, response.status
    end
  end

  context "GET 'division'" do
    setup do
      @division = stub("Division", to_json: "", events: [])
      @calendar = stub("Calendar")
      @calendar.stubs(:division).returns(@division)
      Calendar.stubs(:find).returns(@calendar)
    end

    should "return the json representation of the division" do
      @division.expects(:to_json).returns("json_division")
      @calendar.expects(:division).with('a-division').returns(@division)
      Calendar.expects(:find).with('a-calendar').returns(@calendar)

      get :division, params: { scope: "a-calendar", division: "a-division", format: "json" }
      assert_equal "json_division", @response.body
    end

    should "return the ics representation of the division" do
      @division.expects(:events).returns(:some_events)
      @calendar.expects(:division).with('a-division').returns(@division)
      Calendar.expects(:find).with('a-calendar').returns(@calendar)
      ICSRenderer.expects(:new).with(:some_events, "/a-calendar/a-division.ics").returns(mock("Renderer", render: "ics_division"))

      get :division, params: { scope: "a-calendar", division: "a-division", format: "ics" }
      assert_equal "ics_division", @response.body
    end

    should "set the expiry headers" do
      get :division, params: { scope: "a-calendar", division: "a-division", format: "ics" }
      assert_equal "max-age=86400, public", response.headers["Cache-Control"]
    end

    should "404 for a html request" do
      get :division, params: { scope: "a-calendar", division: "a-division", format: "html" }
      assert_equal 404, @response.status

      get :division, params: { scope: "a-calendar", division: "a-division" }
      assert_equal 404, @response.status
    end

    should "404 with an invalid division" do
      @calendar.stubs(:division).raises(Calendar::CalendarNotFound)

      get :division, params: { scope: 'something', division: 'foo', format: "json" }
      assert_equal 404, response.status
    end

    should "404 for a non-existent calendar" do
      Calendar.stubs(:find).raises(Calendar::CalendarNotFound)

      get :division, params: { scope: 'something', division: 'foo', format: "json" }
      assert_equal 404, response.status
    end

    should "404 without looking up the calendar with an invalid slug format" do
      Calendar.expects(:find).never

      get :division, params: { scope: 'something..etc-passwd', division: 'foo', format: "json" }
      assert_equal 404, response.status
    end
  end
end
