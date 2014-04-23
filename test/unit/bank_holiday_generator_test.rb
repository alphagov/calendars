# encoding: utf-8
require 'bank_holiday_generator'
require_relative '../test_helper'

class BankHolidayGeneratorTest < ActiveSupport::TestCase

  def self.generates_correct_bank_holidays(nation, year, file_name = "bank-holidays_translated.json")
    should "generate bank holidays correctly in #{nation} for year #{year}" do
      bank_holidays = JSON.parse( IO.read(Rails.root+"./test/fixtures/data/#{file_name}") ).fetch("divisions")
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

  nations = ["england-and-wales", "scotland", "northern-ireland"]
  years = (2013..2016)
  nations.each do  |nation|
    years.each do |year|
      I18n.locale = :en
      generates_correct_bank_holidays(nation, year)
      I18n.locale = :cy
      generates_correct_bank_holidays(nation, year, "gwyliau-banc_translated.json")
    end
  end
end
