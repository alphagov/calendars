# encoding: utf-8

require "bank_holiday_generator"
require_relative "../test_helper"

class BankHolidayGeneratorTest < ActiveSupport::TestCase
  def self.generates_correct_bank_holidays(nation, year, locale, file_name)
    should "generate bank holidays correctly in #{nation} for year #{year}" do
      I18n.locale = locale
      bank_holidays = JSON.parse(IO.read(Rails.root + "./test/fixtures/data/#{file_name}")).fetch("divisions")
      bank_holiday_generator = BankHolidayGenerator.new(year, nation)
      generated_bank_holidays = bank_holiday_generator.perform
      translated_bank_holidays = generated_bank_holidays.map { |bank_holiday|
        bank_holiday["title"] = I18n.t(bank_holiday["title"])
        bank_holiday["notes"] = I18n.t(bank_holiday["notes"]) unless bank_holiday["notes"].empty?
        bank_holiday
      }
      assert_equal bank_holidays.fetch(nation).fetch(year.to_s), translated_bank_holidays
    end
  end

  nations = %w(england-and-wales scotland northern-ireland)
  years = (2013..2016)
  nations.each do |nation|
    years.each do |year|
      generates_correct_bank_holidays(nation, year, :en, "bank-holidays_translated.json")
      generates_correct_bank_holidays(nation, year, :cy, "gwyliau-banc_translated.json")
    end
  end

  should "generate bank holidays in order" do
    #In 2016 in England, Christmas (substitute day) is on the 27th and Boxing Day is the 26th.
    # This is one example of why we need to reorder bank holidays by date.
    bank_holiday_generator = BankHolidayGenerator.new(2016, "england-and-wales")
    generated_bank_holidays = bank_holiday_generator.perform
    index_of_christmas = generated_bank_holidays.each_index.find { |i| generated_bank_holidays[i]["title"] == "bank_holidays.christmas" }
    index_of_boxing_day = generated_bank_holidays.each_index.find { |i| generated_bank_holidays[i]["title"] == "bank_holidays.boxing_day" }
    assert index_of_boxing_day < index_of_christmas
  end

  context "new year's day is on a Saturday" do
    #In 2022 New Year's day is on a Saturday
    bank_holiday_generator = BankHolidayGenerator.new(2022, "scotland")
    generated_bank_holidays = bank_holiday_generator.perform
    should "move new year's day to the Tuesday in Scotland" do
      new_year = generated_bank_holidays.find { |holiday| holiday["title"] == "bank_holidays.new_year" }
      assert new_year["date"] == "04/01/2022"
      assert new_year["notes"] == "common.substitute_day"
    end
    should "move January 2nd to the Monday in Scotland" do
      jan_2nd = generated_bank_holidays.find { |holiday| holiday["title"] == "bank_holidays.2nd_january" }
      assert jan_2nd["date"] == "03/01/2022"
      assert jan_2nd["notes"] == "common.substitute_day"
    end
  end

  context "new year's day is on a Sunday" do
    #In 2017 New Year's day is on a Sunday
    bank_holiday_generator = BankHolidayGenerator.new(2017, "scotland")
    generated_bank_holidays = bank_holiday_generator.perform
    should "move new year's day to the Tuesday in Scotland" do
      new_year = generated_bank_holidays.find { |holiday| holiday["title"] == "bank_holidays.new_year" }
      assert new_year["date"] == "03/01/2017"
      assert new_year["notes"] == "common.substitute_day"
    end
    should "does not move January 2nd in Scotland" do
      jan_2nd = generated_bank_holidays.find { |holiday| holiday["title"] == "bank_holidays.2nd_january" }
      assert jan_2nd["date"] == "02/01/2017"
    end
  end
end
