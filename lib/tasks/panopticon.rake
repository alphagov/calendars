require 'registerable_calendar'

namespace :panopticon do
  desc "Register application metadata with panopticon"
  task :register => :environment do
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    Dir.glob(Rails.root.join("lib/data/*.json")).each do |file|
      details = RegisterableCalendar.new(file)
      Services.panopticon.register(details)
    end
  end
end
