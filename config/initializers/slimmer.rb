# This has to be in an initializer and not in application.rb because Rails.logger hasn't
# been setup when application.rb is run.
Calendars::Application.configure do
end
