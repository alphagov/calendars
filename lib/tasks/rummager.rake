require 'registerable_calendar'

namespace :rummager do
  desc "Indexes all calendars in Rummager"
  task index: :environment do
    require 'gds_api/rummager'

    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }

    Dir.glob(Rails.root.join("lib/data/*.json")).each do |file|
      details = RegisterableCalendar.new(file)
      logger.info "Indexing '#{details.title}' in rummager..."

      SearchIndexer.call(details)
    end
  end
end
