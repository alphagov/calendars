source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.8'

gem 'json', '1.7.4'
gem 'exception_notification', '2.5.2'
gem 'aws-ses', '0.4.4', require: 'aws/ses'
gem 'plek', '0.3.0'

gem 'govuk_frontend_toolkit', '0.3.3'

gem 'lograge', '0.0.6'
gem 'unicorn', '4.3.1'

gem 'r18n-rails'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '3.9.4'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '4.1.3'
end

group :test do
  gem 'mocha', '0.10.0', require: false
  gem 'shoulda', '2.11.3'
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov', '0.2.3'
  gem 'webmock', '1.8.0', require: false
  gem 'ci_reporter', '1.6.5'
  gem 'test-unit', '2.5.2'
  gem 'capybara', '1.1.2'
  gem 'timecop', '0.4.5'
end

group :assets do
  gem 'sass-rails', '3.2.3'
  gem 'therubyracer', '0.10.2'
  gem 'uglifier'
end
