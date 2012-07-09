require 'registerable_calendar'

namespace :panopticon do
  desc "Register application metadata with panopticon"
  task :register => :environment do
    require 'gds_api/panopticon'
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    registerer = GdsApi::Panopticon::Registerer.new(
      owning_app: "calendars",
      kind: "answer"
    )
    Dir.glob(Rails.root.join("lib/data/*.json")).each do |file|
      details = RegisterableCalendar.new(file)
      registerer.register(details)
    end
  end
end
