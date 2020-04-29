require "gds_api/test_helpers/content_store"

RSpec.describe CalendarController do
  include GdsApi::TestHelpers::ContentStore

  context "GET 'calendar'" do
    before do
      allow(Calendar).to receive(:find).and_return(Calendar.new("something", "title" => "Brilliant holidays!", "divisions" => []))
      stub_content_store_has_item("/bank-holidays")
      stub_content_store_has_item("/when-do-the-clocks-change")
    end

    context "HTML request (no format)" do
      it "loads the calendar and shows it" do
        get :calendar, params: { scope: "bank-holidays" }
        expect(response.body).to match(/Brilliant holidays!/)
      end

      it "renders the template corresponding to the given calendar" do
        get :calendar, params: { scope: "bank-holidays" }
        expect(response).to render_template(:bank_holidays)
      end

      it "sets the expiry headers" do
        get :calendar, params: { scope: "bank-holidays" }
        expect(response.headers["Cache-Control"]).to eq("max-age=3600, public")
      end
    end

    context "for a welsh language content item" do
      it "sets the I18n locale" do
        content_item = content_item_for_base_path("/bank-holidays")
        content_item["locale"] = "cy"
        stub_content_store_has_item("/bank-holidays", content_item)
        get :calendar, params: { scope: "gwyliau-banc", locale: "cy" }
        expect(I18n.locale).to be(:cy)
      end
    end

    context "json request" do
      it "loads the calendar and return its json representation" do
        allow(Calendar).to receive(:find).with("bank-holidays").and_return(double("Calendar", to_json: "json_calendar"))

        get :calendar, params: { scope: "bank-holidays", format: :json }

        expect(response.body).to eq("json_calendar")
      end

      it "sets the expiry headers" do
        get :calendar, params: { scope: "bank-holidays", format: :json }
        expect(response.headers["Cache-Control"]).to eq("max-age=3600, public")
      end

      it "sets the CORS headers" do
        get :calendar, params: { scope: "bank-holidays", format: :json }

        expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      end
    end

    it "404s for a non-existent calendar" do
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)

      get :calendar, params: { scope: "something" }
      expect(response).to have_http_status(404)
    end

    it "404s without looking up the calendar with an invalid slug format" do
      allow(Calendar).to receive(:find).and_raise(Exception)

      get :calendar, params: { scope: "something..etc-passwd" }
      expect(response).to have_http_status(404)
    end

    it "403s if content store returns forbidden response" do
      stub_request(:get, "#{Plek.find('content-store')}/content/something-access-limited")
        .to_return(status: 403, headers: {})

      get :calendar, params: { scope: "something-access-limited" }
      expect(response).to have_http_status(403)
    end
  end

  context "GET 'division'" do
    before do
      @division = double("Division", to_json: "", events: [])
      @calendar = double("Calendar")
      allow(@calendar).to receive(:division).and_return(@division)
      allow(Calendar).to receive(:find).and_return(@calendar)
    end

    it "returns the json representation of the division" do
      allow(@division).to receive(:to_json).and_return("json_division")
      allow(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)

      get :division, params: { scope: "a-calendar", division: "a-division", format: "json" }
      expect(response.body).to eq("json_division")
    end

    it "returns the ics representation of the division" do
      allow(@division).to receive(:events).and_return(:some_events)
      allow(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)
      allow(ICSRenderer).to receive(:new).with(:some_events, "/a-calendar/a-division.ics").and_return(double("Renderer", render: "ics_division"))

      get :division, params: { scope: "a-calendar", division: "a-division", format: "ics" }
      expect(response.body).to eq("ics_division")
    end

    it "sets the expiry headers" do
      get :division, params: { scope: "a-calendar", division: "a-division", format: "ics" }
      expect(response.headers["Cache-Control"]).to eq("max-age=86400, public")
    end

    it "404s for a html request" do
      get :division, params: { scope: "a-calendar", division: "a-division", format: "html" }
      expect(response).to have_http_status(404)

      get :division, params: { scope: "a-calendar", division: "a-division" }
      expect(response).to have_http_status(404)
    end

    it "404s with an invalid division" do
      allow(@calendar).to receive(:division).and_raise(Calendar::CalendarNotFound)

      get :division, params: { scope: "something", division: "foo", format: "json" }
      expect(response).to have_http_status(404)
    end

    it "404s for a non-existent calendar" do
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)

      get :division, params: { scope: "something", division: "foo", format: "json" }
      expect(response).to have_http_status(404)
    end

    it "404s without looking up the calendar with an invalid slug format" do
      allow(Calendar).to receive(:find).and_raise(Exception)

      get :division, params: { scope: "something..etc-passwd", division: "foo", format: "json" }
      expect(response).to have_http_status(404)
    end
  end
end
