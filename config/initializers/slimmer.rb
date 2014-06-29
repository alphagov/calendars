# This has to be in an initializer and not in application.rb because Rails.logger hasn't
# been setup when application.rb is run.
Calendars::Application.configure do
  config.slimmer.logger = Rails.logger

  config.slimmer.use_cache = true if Rails.env.production?

  if Rails.env.development?
    config.slimmer.asset_host = ENV["STATIC_DEV"] || "http://static.dev.gov.uk"
  end
end
