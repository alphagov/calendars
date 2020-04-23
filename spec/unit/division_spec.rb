# encoding: utf-8

RSpec.describe Calendar::Division do
  it "returns the slug" do
    expect(Calendar::Division.new("a-slug", {}).slug).to eq("a-slug")
  end

  it "returns the slug for to_param" do
    expect(Calendar::Division.new("a-slug", {}).to_param).to eq("a-slug")
  end

  context "title" do
    it "returns the title from the data if given" do
      d = Calendar::Division.new("a-slug", "title" => "something")
      expect(d.title).to eq("something")
    end

    it "humanizes the slug otherwise" do
      d = Calendar::Division.new("a-slug", {})
      expect(d.title).to eq("A slug")
    end
  end

  context "years" do
    it "construct a year for each one in the data" do
      div = Calendar::Division.new("something", "2012" => [1, 2],
        "2013" => [3, 4])
      allow(Calendar::Year).to receive(:new).with("2012", div, [1, 2]).and_return(:y_2012)
      allow(Calendar::Year).to receive(:new).with("2013", div, [3, 4]).and_return(:y_2013)

      expect(div.years).to eq(%i[y_2012 y_2013])
    end

    it "cache the constructed instances" do
      div = Calendar::Division.new("something", "2012" => [1, 2],
        "2013" => [3, 4])

      first = div.years
      allow(Calendar::Year).to receive(:new).and_raise(Exception)
      expect(div.years).to eq(first)
    end

    it "ignore non-year keys in the data" do
      div = Calendar::Division.new("something", "title" => "A Thing",
        "2012" => [1, 2],
        "2013" => [3, 4],
        "foo" => "bar")

      allow(Calendar::Year).to receive(:new).with("2012", div, [1, 2]).and_return(:y_2012)
      allow(Calendar::Year).to receive(:new).with("2013", div, [3, 4]).and_return(:y_2013)
      allow(Calendar::Year).to receive(:new).with("title", anything, anything).and_raise(Exception)
      allow(Calendar::Year).to receive(:new).with("foo", anything, anything).and_raise(Exception)

      expect(div.years).to eq(%i[y_2012 y_2013])
    end

    context "finding a year by name" do
      before do
        @div = Calendar::Division.new("something", "title" => "A Division",
          "2012" => [1, 2],
          "2013" => [3, 4])
      end

      it "returns the year with the matching name" do
        y = @div.year("2013")
        expect(y.class).to eq(Calendar::Year)
        expect(y.to_s).to eq("2013")
      end

      it "raises exception when division doesn't exist" do
        expect { @div.year("non-existent") }.to raise_error(Calendar::CalendarNotFound)
      end
    end
  end

  context "events" do
    before do
      @years = []
      @div = Calendar::Division.new("something")
      allow(@div).to receive(:years).and_return(@years)
    end

    it "merges events for all years into single array" do
      @years << double("Year1", events: [1, 2])
      @years << double("Year2", events: [3, 4, 5])
      @years << double("Year3", events: [6, 7])

      expect(@div.events).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "handles years with no events" do
      @years << double("Year1", events: [1, 2])
      @years << double("Year2", events: [])
      @years << double("Year3", events: [6, 7])

      expect(@div.events).to eq([1, 2, 6, 7])
    end
  end

  context "upcoming event" do
    before do
      @years = []
      @div = Calendar::Division.new("something")
      allow(@div).to receive(:years).and_return(@years)
    end

    it "return nil with no years" do
      expect(@div.upcoming_event).to be_nil
    end

    it "returns nil if no years have upcoming_events" do
      @years << double("Year1", upcoming_event: nil)
      @years << double("Year2", upcoming_event: nil)
      expect(@div.upcoming_event).to be_nil
    end

    it "returns the upcoming event for the first year that has one" do
      @years << double("Year1", upcoming_event: nil)
      @years << double("Year2", upcoming_event: :event_1)
      @years << double("Year3", upcoming_event: :event_2)

      expect(@div.upcoming_event).to be(:event_1)
    end

    it "caches the event" do
      y1 = double("Year1")
      y2 = double("Year2", upcoming_event: :event_1)
      @years << y1
      @years << y2

      allow(y1).to receive(:upcoming_event).and_return(nil)
      @div.upcoming_event
      expect(@div.upcoming_event).to be(:event_1)
    end
  end

  context "upcoming_events_by_year" do
    before do
      @years = []
      @div = Calendar::Division.new("something")
      allow(@div).to receive(:years).and_return(@years)
    end

    it "returns a hash of year => events for upcoming events" do
      y1 = double("Year1", upcoming_events: %i[e1 e2])
      y2 = double("Year2", upcoming_events: %i[e3 e4 e5])
      @years << y1 << y2

      expected = {
        y1 => %i[e1 e2],
        y2 => %i[e3 e4 e5],
      }
      expect(@div.upcoming_events_by_year).to eq(expected)
    end

    it "not include any years with no upcoming events" do
      y1 = double("Year1", upcoming_events: [])
      y2 = double("Year2", upcoming_events: %i[e1 e2 e3])
      @years << y1 << y2

      expected = {
        y2 => %i[e1 e2 e3],
      }
      expect(@div.upcoming_events_by_year).to eq(expected)
    end
  end

  context "past_events_by_year" do
    before do
      @years = []
      @div = Calendar::Division.new("something")
      allow(@div).to receive(:years).and_return(@years)
    end

    it "returns a hash of year => reversed events for past events" do
      y1 = double("Year1", past_events: %i[e1 e2])
      y2 = double("Year2", past_events: %i[e3 e4 e5])
      @years << y1 << y2

      expected = {
        y1 => %i[e2 e1],
        y2 => %i[e5 e4 e3],
      }
      events_by_year = @div.past_events_by_year
      expect(events_by_year).to eq(expected)
      expect(events_by_year.keys).to eq([y2, y1]) # Assert ordering of Hash
    end

    it "excludes any years with no past events" do
      y1 = double("Year1", past_events: %i[e1 e2])
      y2 = double("Year2", past_events: [])
      @years << y1 << y2

      expected = {
        y1 => %i[e2 e1],
      }
      expect(@div.past_events_by_year).to eq(expected)
    end
  end

  context "show_bunting?" do
    before do
      @div = Calendar::Division.new("something")
    end

    it "is true if there is a buntable bank holiday today" do
      @event = double("Event", bunting: true, date: Time.zone.today)
      allow(@div).to receive(:upcoming_event).and_return(@event)

      expect(@div.show_bunting?).to be(true)
    end

    it "is false if there is a non-buntable bank holiday today" do
      @event = double("Event", bunting: false, date: Time.zone.today)
      allow(@div).to receive(:upcoming_event).and_return(@event)

      expect(@div.show_bunting?).to be(false)
    end

    it "is false if there is no bank holiday today" do
      @event = double("Event", bunting: true, date: Time.zone.today + 1.week)
      allow(@div).to receive(:upcoming_event).and_return(@event)

      expect(@div.show_bunting?).to be(false)
    end
  end

  context "as_json" do
    before do
      @div = Calendar::Division.new("something")
    end

    it "returns division slug" do
      hash = @div.as_json
      expect(hash["division"]).to eq("something")
    end

    it "returns all events from all years" do
      y1 = double("Year", events: [1, 2])
      y2 = double("Year", events: [3, 4])
      allow(@div).to receive(:years).and_return([y1, y2])

      hash = @div.as_json
      expect(hash["events"]).to eq([1, 2, 3, 4])
    end
  end
end
