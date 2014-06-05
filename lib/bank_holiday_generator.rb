# encoding: utf-8
#Bank holidays are determined both by law and by proclamation.
#Link to the legislation to determine bank holidays:
#  http://www.legislation.gov.uk/ukpga/1971/80/schedule/1
#  and
#  http://www.legislation.gov.uk/asp/2007/2/section/1
#Link to where to find proclamations of bank holidays:
#  https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial"
#  Holidays are announced there 6 months to one year in advance, between the months of May and July for the following year.

class BankHolidayGenerator

  def initialize(year, nation, specify_proclamation=false)
    @year = year
    @nation = nation
    @specify_proclamation = specify_proclamation
    @bank_holidays = []
  end

  BANK_HOLIDAYS = {
    "england-and-wales" => {
      :new_years_day      => true,
      :good_friday        => true,
      :easter_monday      => true,
      :early_may          => true,
      :spring             => false,
      :last_monday_august => false,
      :christmas          => false,
      :boxing_day         => false,
    },

    "scotland" => {
      :new_years_day_second_january_off => false,
      :second_january                   => false,
      :good_friday                      => false,
      :early_may                        => false,
      :spring                           => true,
      :first_monday_august              => false,
      :st_andrews                       => false,
      :christmas                        => false,
      :boxing_day                       => true,
    },

    "northern-ireland" => {
      :new_years_day      => true,
      :st_patricks        => false,
      :good_friday        => true,
      :easter_monday      => false,
      :early_may          => true,
      :spring             => false,
      :battle_boyne       => true,
      :last_monday_august => false,
      :christmas          => false,
      :boxing_day         => false,
    }
  }

  attr_reader :year, :bank_holidays, :nation, :specify_proclamation

  def perform
    BANK_HOLIDAYS.fetch(nation).each do |bank_holiday_name, by_proclamation|
      send(bank_holiday_name, by_proclamation)
    end
    bank_holidays.sort_by{|bh_hash| DateTime.parse(bh_hash.fetch("date"))}
  end

private

  def add_bank_holiday(title, date, by_proclamation, substitute=false, bunting=true)
    bank_holiday_hash = {
        "title"           => title,
        "date"            => date.strftime("%d/%m/%Y"),
        "notes"           => "",
        "bunting"         => bunting,
    }
    if specify_proclamation
      bank_holiday_hash.merge!(
          { "by_proclamation" => by_proclamation }
      )
    end
    if substitute
      bank_holiday_hash.merge!(
        { "notes" => "common.substitute_day" }
      )
    end
    bank_holidays << bank_holiday_hash
  end


  def new_years_day(by_proclamation, second_january_off = false)
    date = Date.new(year, 1, 1)
    if second_january_off && date.saturday?
      new_date = date + 3
      by_proclamation = true
    elsif second_january_off
      new_date = substitute_day_next_day_off(date)
    else
      new_date = substitute_day(date)
    end
    add_bank_holiday("bank_holidays.new_year", new_date, by_proclamation, new_date != date)
  end

  def new_years_day_second_january_off(by_proclamation)
    new_years_day(by_proclamation, true)
  end

  def second_january(by_proclamation)
    date = Date.new(year, 1, 2)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.2nd_january", new_date, by_proclamation, new_date != date)
  end

  def st_patricks(by_proclamation)
    date = Date.new(year, 3, 17)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.st_patrick", new_date, by_proclamation, new_date != date)
  end

  def good_friday(by_proclamation)
    date = easter-2
    add_bank_holiday("bank_holidays.good_friday", date, by_proclamation, false, false)
  end

  def easter_monday(by_proclamation)
    date = easter+1
    add_bank_holiday("bank_holidays.easter_monday", date, by_proclamation)
  end

  def early_may(by_proclamation)
    date = first_monday_of_month(year, 5)
    add_bank_holiday("bank_holidays.early_may", date, by_proclamation)
  end

  def spring(by_proclamation)
    date = last_monday_of_month(year, 5)
    add_bank_holiday("bank_holidays.spring", date, by_proclamation)
  end

  def battle_boyne(by_proclamation)
    date = Date.new(year, 7, 12)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.battle_boyne", new_date, by_proclamation, new_date != date, false)
  end

  def first_monday_august(by_proclamation)
    date = first_monday_of_month(year, 8)
    add_bank_holiday("bank_holidays.summer", date, by_proclamation)
  end

  def last_monday_august(by_proclamation)
    date = last_monday_of_month(year, 8)
    add_bank_holiday("bank_holidays.late_august", date, by_proclamation)
  end

  def st_andrews(by_proclamation)
    date = Date.new(year, 11, 30)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.st_andrew", new_date, by_proclamation, new_date != date)
  end

  def christmas(by_proclamation)
    date = Date.new(year, 12, 25)
    new_date = substitute_day_next_day_off(date)
    add_bank_holiday("bank_holidays.christmas", new_date, by_proclamation, new_date != date)
  end

  def boxing_day(by_proclamation)
    date = Date.new(year, 12, 26)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.boxing_day", new_date, by_proclamation, new_date != date)
  end

  #Date utilities

  def first_monday_of_month(year, month)
    Date.new(year, month, 1).upto(Date.new(year, month, -1)).find {|day| day.monday? }
  end

  def last_monday_of_month(year, month)
    Date.new(year, month, -1).downto(0).find {|day| day.monday? }
  end

  #The following code comes from:
  #https://github.com/alexdunae/holidays
  def easter
    a = year % 19
    b = year / 100
    c = year % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    month = (h + l - 7 * m + 114) / 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    Date.civil(year, month, day)
  end

  def substitute_day(date)
    if date.saturday?
      date += 2
    elsif date.sunday?
      date += 1
    end
    date
  end

  def substitute_day_next_day_off(date)
    if date.saturday? || date.sunday?
      date += 2
    end
    date
  end
end
