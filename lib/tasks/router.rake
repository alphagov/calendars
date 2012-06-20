require 'router'
require 'logger'

namespace :router do
  task :router_environment => :environment do
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG
    @router = Router.new("http://router.cluster:8080/router", @logger)
    @application_name = "calendars"
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "#{@application_name}.#{platform}.alphagov.co.uk"
    @logger.info "Registering application..."
    @router.update_application @application_name, url
  end

  task :register_routes => :router_environment do
    Calendar.all_slugs.each do |slug|
      path = "#{slug}".gsub('_', '-')
      @logger.info "Registering #{path}"
      @router.create_route path, "prefix", @application_name
      @router.create_route "#{path}.json", "full", @application_name
    end
  end

  desc "Register calendars application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end
