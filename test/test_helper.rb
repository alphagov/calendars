require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

require 'mocha/setup'
require 'mocha/minitest'
require 'slimmer/test'

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'publisher_v2'
  config.project_root = Rails.root
end

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  setup do
    I18n.locale = :en
  end

  teardown do
    I18n.locale = :en
  end
end
