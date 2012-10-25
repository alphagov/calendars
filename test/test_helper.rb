require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha'
require 'slimmer/skin'
require 'slimmer/test'

require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
