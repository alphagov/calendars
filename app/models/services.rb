require 'gds_api/panopticon'
require 'gds_api/publishing_api'

module Services
  def self.panopticon
    @panopticon ||= GdsApi::Panopticon::Registerer.new(owning_app: "calendars")
  end

  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(Plek.new.find('publishing-api'))
  end
end
