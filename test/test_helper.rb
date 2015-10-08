require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/setup'
require 'slimmer/test'

require 'webmock/minitest'
WebMock.disable_net_connect!(:allow_localhost => true)

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'publisher'
  config.project_root = Rails.root
end

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }
