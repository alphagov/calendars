namespace :rummager do
  desc "Indexes all calendars in Rummager"
  task index: :environment do
    require 'gds_api/rummager'

    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }

    %w[bank-holidays when-do-the-clocks-change].each do |slug|
      calendar = Calendar.find(slug)
      logger.info "Indexing '#{calendar.title}' in rummager..."

      SearchIndexer.call(calendar)
    end
  end
end
