require 'gds_api/panopticon'

module Services
  def self.panopticon
    @panopticon ||= GdsApi::Panopticon::Registerer.new(owning_app: "calendars")
  end
end
