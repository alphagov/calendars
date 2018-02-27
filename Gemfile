source 'https://rubygems.org'

ruby File.read(".ruby-version").chomp

gem 'rails', '~> 5.0.3'
gem 'rails-i18n', '~> 5.0.4'

gem 'json', '~> 2.1.0'
gem 'plek', '2.1.1'

gem 'govuk_frontend_toolkit', '~> 7.4.1'
gem 'govuk_publishing_components', '~> 5.2.0'
gem 'govuk_navigation_helpers', '~> 7.3.0'

gem 'rack_strip_client_ip', '0.0.2'

gem 'sass-rails', '5.0.7'
gem 'uglifier', '4.1.5'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 12.0.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', "~> 51.3.0"
end

group :test, :development do
  gem 'govuk-lint', '3.6.0'
  gem 'pry-byebug'
end

group :test do
  gem 'rails-controller-testing'
  gem 'mocha', '1.2.1', require: false
  gem 'shoulda', '3.5.0'
  gem 'simplecov', '0.15.1'
  gem 'simplecov-rcov', '0.2.3'
  gem 'webmock', '~> 3.3.0', require: false
  gem 'ci_reporter_minitest', '1.0.0'
  gem 'capybara', '2.14.0'
  gem 'timecop', '0.9.1'
  gem 'govuk-content-schema-test-helpers', '~> 1.4.0'
end

# Upgrade to Sentry
gem "govuk_app_config", "~> 1.3.1"
