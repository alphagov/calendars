require 'gds_api/publishing_api_v2'
require 'gds_api/rummager'

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example'
    )
  end

  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.find("search"))
  end
end
