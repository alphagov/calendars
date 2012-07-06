require_relative '../test_helper'

require 'gds_api/panopticon'
require 'registerable_calendar'

class PanopticonRegistrationTest < ActiveSupport::TestCase
  context "Panopticon registration" do
    should "translate to Panopticon artefacts" do
      registerer = GdsApi::Panopticon::Registerer.new(owning_app: "calendars")
      file_path = Dir.glob(Rails.root.join("lib/data/*.json")).first

      calendar = RegisterableCalendar.new(file_path)
      artefact = registerer.record_to_artefact(calendar)

      [:name, :description, :slug, :section].each do |key|
        assert artefact.has_key?(key), "Missing attribute: #{key}"
        assert ! artefact[key].nil?, "Attribute #{key} is nil"
      end

      assert artefact[:live], "Is not live"
    end
  end
end
