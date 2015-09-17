namespace :publishing_api do
  desc "Send pages to the content-api"
  task :register => :environment do
    %w[bank-holidays when-do-the-clocks-change].each do |calender_name|
      calendar = Calendar.find(calender_name)
      CalendarPublisher.new(calendar).publish
    end
  end
end
