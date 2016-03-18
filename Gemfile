source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'rails-i18n', '4.0.8'

gem 'json', '~> 1.8.3'
gem 'plek', '1.12.0'

gem 'govuk_frontend_toolkit', '~> 4.9.0'

gem 'logstasher', '0.4.8'
gem 'airbrake', '4.3.0'
gem 'rack_strip_client_ip', '0.0.1'
gem 'unicorn', '~> 5.0.0'

gem 'sass-rails', '5.0.4'
gem 'uglifier', '2.7.2'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '9.1.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 29.6'
end

group :test, :development do
  gem 'pry-byebug'
end

group :test do
  gem 'mocha', '1.1.0', require: false
  gem 'shoulda', '3.5.0'
  gem 'simplecov', '0.10.0'
  gem 'simplecov-rcov', '0.2.3'
  gem 'webmock', '1.24.2', require: false
  gem 'ci_reporter_minitest', '1.0.0'
  gem 'capybara', '2.6.2'
  gem 'timecop', '0.8.0'
  gem 'govuk-content-schema-test-helpers', '~> 1.4.0'
end
