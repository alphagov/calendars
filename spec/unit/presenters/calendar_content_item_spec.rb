RSpec.describe CalendarContentItem do
  let(:calendar) { Calendar.find("bank-holidays") }

  it "is valid against the schema" do
    expect(CalendarContentItem.new(calendar).payload).to be_valid_against_schema("calendar")
  end

  it "contains the correct title" do
    expect(CalendarContentItem.new(calendar).payload[:title]).to eq("UK bank holidays")
  end

  it "contains the correct base path" do
    expect(CalendarContentItem.new(calendar).base_path).to eq("/bank-holidays")
  end
end
