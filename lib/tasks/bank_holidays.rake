require "bank_holiday_generator"

namespace :bank_holidays do
  desc "Generate JSON for UK bank holidays"
  task :generate_json, [:year] => :environment do |_t, args|
    year = args[:year].to_i
    if year != 0
      nations = %w[england-and-wales scotland northern-ireland]
      nations.each do |nation|
        generator = BankHolidayGenerator.new(year, nation)
        bank_holidays = generator.perform
        File.write("bank_holidays_#{year}_#{nation}.json", JSON.pretty_generate(bank_holidays))
      end
    else
      p "Please enter the year that you want to generate bank holidays for"
    end
  end
end
