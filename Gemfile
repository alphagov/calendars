source 'https://rubygems.org'

ruby File.read(".ruby-version").chomp

gem 'rails', '~> 5.2.3'
gem 'rails-i18n', '~> 5.1.3'

gem 'json', '~> 2.2.0'
gem 'plek', '2.1.1'

gem 'govuk_publishing_components', '~> 16.12.0'

gem 'rack_strip_client_ip', '0.0.2'

gem 'sass-rails', '5.0.7'
gem 'uglifier', '4.1.20'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 13.1.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters'
end

group :test, :development do
  gem 'govuk-lint', '3.11.0'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara', '3.18.0'
  gem 'ci_reporter_minitest', '1.0.0'
  gem 'govuk-content-schema-test-helpers', '~> 1.6.1'
  gem 'mocha', '1.8.0', require: false
  gem 'rails-controller-testing'
  gem 'shoulda', '3.6.0'
  gem 'simplecov', '0.16.1'
  gem 'simplecov-rcov', '0.2.3'
  gem 'timecop', '0.9.1'
  gem 'webmock', '~> 3.5.1', require: false
end

# Upgrade to Sentry
gem "govuk_app_config", "~> 1.15.1"
