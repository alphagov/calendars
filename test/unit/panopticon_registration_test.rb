require_relative '../test_helper'

require 'gds_api/panopticon'
require 'registerable_calendar'

class PanopticonRegistrationTest < ActiveSupport::TestCase
  context "Panopticon registration" do
    should "translate to Panopticon artefacts" do
      file_path = Rails.root.join(*%w(lib data bank-holidays.json))
      registerer = GdsApi::Panopticon::Registerer.new(owning_app: "calendars")

      calendar = RegisterableCalendar.new(file_path)
      artefact = registerer.record_to_artefact(calendar)

      [:name, :description, :slug, :content_id].each do |key|
        assert artefact.has_key?(key), "Missing attribute: #{key}"
        assert ! artefact[key].nil?, "Attribute #{key} is nil"
      end

      assert_equal ["/bank-holidays.json"], artefact[:paths]
      assert_equal ["/bank-holidays"], artefact[:prefixes]

      assert_equal 'live', artefact[:state], "Is not live"
    end
  end
end
