require "byebug"
require "simplecov"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "slimmer/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
SimpleCov.start

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
