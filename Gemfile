source 'https://rubygems.org'

ruby File.read(".ruby-version").chomp

gem 'rails', '~> 5.2.0'
gem 'rails-i18n', '~> 5.1.1'

gem 'json', '~> 2.1.0'
gem 'plek', '2.1.1'

gem 'govuk_frontend_toolkit', '~> 7.5.0'
gem 'govuk_publishing_components', '~> 9.5.1'

gem 'rack_strip_client_ip', '0.0.2'

gem 'sass-rails', '5.0.7'
gem 'uglifier', '4.1.14'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 13.0.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', "~> 52.6.0"
end

group :test, :development do
  gem 'govuk-lint', '3.8.0'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara', '3.3.1'
  gem 'ci_reporter_minitest', '1.0.0'
  gem 'govuk-content-schema-test-helpers', '~> 1.6.1'
  gem 'mocha', '1.5.0', require: false
  gem 'rails-controller-testing'
  gem 'shoulda', '3.6.0'
  gem 'simplecov', '0.16.1'
  gem 'simplecov-rcov', '0.2.3'
  gem 'timecop', '0.9.1'
  gem 'webmock', '~> 3.4.2', require: false
end

# Upgrade to Sentry
gem "govuk_app_config", "~> 1.6.0"
