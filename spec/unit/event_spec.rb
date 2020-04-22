# encoding: utf-8

RSpec.describe Calendar::Event do
  context "construction" do
    it "parses a date given as a string" do
      e = Calendar::Event.new("date" => "2012-02-04")
      expect(e.date).to eq(Date.civil(2012, 2, 4))
    end

    it "allows construction with dates as well as string dates" do
      e = Calendar::Event.new("date" => Date.civil(2012, 2, 4))
      expect(e.date).to eq(Date.civil(2012, 2, 4))
    end
  end

  context "as_json in English" do
    it "returns a hash representation" do
      I18n.locale = :en
      e = Calendar::Event.new(
        "title" => "bank_holidays.new_year",
        "date" => "02/01/2012",
        "notes" => "common.substitute_day",
        "bunting" => true,
      )

      expected = {
        "title" => "New Year’s Day",
        "date" => Date.civil(2012, 1, 2),
        "notes" => "Substitute day",
        "bunting" => true,
      }

      expect(e.as_json).to eq(expected)
    end
  end
end
