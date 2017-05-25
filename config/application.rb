require_relative 'boot'

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Calendars
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.eager_load_paths += %W(#{config.root}/lib)
    config.eager_load_paths += %W(#{config.root}/app/services)

    # This saves loading all 80-odd locales from the rails-i18n gem.  This doesn't affect the loading
    # of locales from config/locales
    config.i18n.available_locales = [:en, :cy]

    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.prefix = '/calendars'
    config.assets.precompile += %w(
      application.css
      print.css
    )

    # Disable Rack::Cache.
    config.action_dispatch.rack_cache = nil

    config.action_dispatch.ignore_accept_header = true
  end
end
