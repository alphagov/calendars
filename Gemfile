source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.1.3'
gem 'gds-warmup-controller'

group :router do
  gem 'router-client', '~> 3.0.1', require: 'router'
end

# passenger compatability
group :passenger_compatibility do
  gem 'rack', '1.3.5'
  gem 'rake', '0.9.2'
end

gem 'json'
gem 'jquery-rails'
gem 'exception_notification'

gem 'aws-ses', require: 'aws/ses'
gem "ri_cal", "~> 0.8.8"
gem 'plek', '~> 0'

gem 'gelf'
gem 'graylog2_exceptions'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '1.1.42'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 0.1.1'
end

group :test do
  gem 'factory_girl_rails'
  gem 'mocha', require: false
  gem "shoulda", "~> 2.11.3"
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov'
  gem 'webmock', require: false
  gem 'ci_reporter'
  gem 'test-unit'
  gem 'capybara'
  gem "capybara-webkit"
  gem 'turn', require: false
  gem 'timecop'
end

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem "therubyracer", "~> 0.9.4"
  gem 'uglifier'
end
