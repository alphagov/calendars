# encoding: utf-8

RSpec.describe Calendar do
  context "finding a calendar by slug" do
    it "constructs a calendar with the slug and data from the corresponding JSON file" do
      data_from_json = JSON.parse(File.read(Rails.root.join(Calendar::REPOSITORY_PATH, "single-calendar.json")))
      allow(Calendar).to receive(:new).with("single-calendar", data_from_json).and_return(:a_calendar)

      cal = Calendar.find("single-calendar")
      expect(cal).to be(:a_calendar)
    end

    it "raises exception when calendar doesn't exist" do
      expect { Calendar.find("non-existent") }.to raise_error(Calendar::CalendarNotFound)
    end
  end

  it "returns the slug" do
    expect(Calendar.new("a-slug", {}).slug).to eq("a-slug")
  end

  it "returns the slug for to_param" do
    expect(Calendar.new("a-slug", {}).to_param).to eq("a-slug")
  end

  context "divisions" do
    before do
      @cal = Calendar.new("a-calendar", "title" => "UK bank holidays",
                                        "divisions" => {
          "kablooie" => {
            "2012" => [1],
            "2013" => [3],
          },
          "fooey" => {
            "2012" => [1, 2],
            "2013" => [3, 4],
          },
          "gooey" => {
            "2012" => [2],
            "2013" => [4],
          },
        })
    end

    it "constructs a division for each one in the data" do
      allow(Calendar::Division).to receive(:new).with("kablooie", "2012" => [1], "2013" => [3]).and_return(:kablooie)
      allow(Calendar::Division).to receive(:new).with("fooey", "2012" => [1, 2], "2013" => [3, 4]).and_return(:fooey)
      allow(Calendar::Division).to receive(:new).with("gooey", "2012" => [2], "2013" => [4]).and_return(:gooey)

      expect(@cal.divisions).to eq(%i[kablooie fooey gooey])
    end

    it "caches the constructed instances" do
      first = @cal.divisions
      allow(Calendar::Division).to receive(:new).and_raise(Exception)
      expect(@cal.divisions).to eq(first)
    end

    context "finding a division by slug" do
      it "returns the division with the matching slug" do
        div = @cal.division("fooey")
        expect(div.class).to eq(Calendar::Division)
        expect(div.title).to eq("Fooey")
      end

      it "raises exception when division doesn't exist" do
        expect { @cal.division("non-existent") }.to raise_error(Calendar::CalendarNotFound)
      end
    end
  end

  context "events" do
    before do
      @divisions = []
      @calendar = Calendar.new("a-calendar")
      allow(@calendar).to receive(:divisions).and_return(@divisions)
    end

    it "merges events for all years into single array" do
      @divisions << double("Division1", events: [1, 2])
      @divisions << double("Division2", events: [3, 4, 5])
      @divisions << double("Division3", events: [6, 7])

      expect(@calendar.events).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "handles years with no events" do
      @divisions << double("Division1", events: [1, 2])
      @divisions << double("Division2", events: [])
      @divisions << double("Division3", events: [6, 7])

      expect(@calendar.events).to eq([1, 2, 6, 7])
    end
  end

  context "attribute accessors" do
    before do
      @cal = Calendar.new("a-calendar", "title" => "UK bank holidays",
                                        "description" => "UK bank holidays description")
    end

    it "has an accessor for the title" do
      expect(@cal.title).to eq("UK bank holidays")
    end

    it "has an accessor for the description" do
      expect(@cal.description).to eq("UK bank holidays description")
    end
  end

  context "show_bunting?" do
    before do
      @cal = Calendar.new("a-calendar")
    end

    it "is true when one division is buntable" do
      @div1 = double("Division", show_bunting?: true)
      @div2 = double("Division", show_bunting?: false)
      @div3 = double("Division", show_bunting?: false)
      allow(@cal).to receive(:divisions).and_return([@div1, @div2, @div3])

      expect(@cal.show_bunting?).to be(true)
    end

    it "is true when more than one division is buntable" do
      @div1 = double("Division", show_bunting?: true)
      @div2 = double("Division", show_bunting?: true)
      @div3 = double("Division", show_bunting?: false)
      allow(@cal).to receive(:divisions).and_return([@div1, @div2, @div3])

      expect(@cal.show_bunting?).to be(true)
    end

    it "is false when no divisions are buntable" do
      @div1 = double("Division", show_bunting?: false)
      @div2 = double("Division", show_bunting?: false)
      @div3 = double("Division", show_bunting?: false)
      allow(@cal).to receive(:divisions).and_return([@div1, @div2, @div3])

      expect(@cal.show_bunting?).to be(false)
    end
  end

  context "as_json" do
    before do
      @div1 = double("Division", slug: "division-1", as_json: "div1 json")
      @div2 = double("Division", slug: "division-2", as_json: "div2 json")
      @cal = Calendar.new("a-calendar")
      allow(@cal).to receive(:divisions).and_return([@div1, @div2])
    end

    it "constructs a hash representation of all divisions" do
      expected = {
        "division-1" => "div1 json",
        "division-2" => "div2 json",
      }
      expect(@cal.as_json).to eq(expected)
    end
  end
end
