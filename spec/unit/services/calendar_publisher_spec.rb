RSpec.describe CalendarPublisher do
  it "publishes to the publishing api" do
    allow(Services.publishing_api).to receive(:put_content).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", be_valid_against_schema("calendar")).once
    allow(Services.publishing_api).to receive(:publish).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2").once
    allow(Services.publishing_api).to receive(:patch_links).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", links: { primary_publishing_organisation: %w(af07d5a5-df63-4ddc-9383-6a666845ebe9) }).once

    calendar = Calendar.find("bank-holidays")

    CalendarPublisher.new(calendar).publish
  end
end
