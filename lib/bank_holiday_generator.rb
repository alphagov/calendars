# encoding: utf-8

# Bank holidays are determined both by law and by proclamation.
# Link to the legislation to determine bank holidays:
#  http://www.legislation.gov.uk/ukpga/1971/80/schedule/1
#  and
#  http://www.legislation.gov.uk/asp/2007/2/section/1
# Link to where to find proclamations of bank holidays:
#  https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial"
#  Holidays are announced there 6 months to one year in advance, between the months of May and July for the following year.

class BankHolidayGenerator
  def initialize(year, nation)
    @year = year
    @nation = nation
    @bank_holidays = []
  end

  BANK_HOLIDAYS = {
    "england-and-wales" => [
      :new_years_day, # by proclamation
      :good_friday,   # by proclamation
      :easter_monday, # by proclamation
      :early_may,     # by proclamation
      :spring,
      :last_monday_august,
      :christmas,
      :boxing_day,
    ],

    "scotland" => [
      :new_years_day_second_january_off,
      :second_january,
      :good_friday,
      :early_may,
      :spring,        # by proclamation
      :first_monday_august,
      :st_andrews,
      :christmas,
      :boxing_day,    # by proclamation
    ],

    "northern-ireland" => [
      :new_years_day, # by proclamation
      :st_patricks,
      :good_friday,   # by proclamation
      :easter_monday,
      :early_may,     # by proclamation
      :spring,
      :battle_boyne,  # by proclamation
      :last_monday_august,
      :christmas,
      :boxing_day,
    ],
  }.freeze

  attr_reader :year, :bank_holidays, :nation

  def perform
    BANK_HOLIDAYS.fetch(nation).each do |bank_holiday|
      send(bank_holiday)
    end
    bank_holidays.sort_by { |bh_hash| Date.parse(bh_hash.fetch("date")) }
  end

private

  def add_bank_holiday(title, date, substitute = false, bunting = true)
    bank_holiday_hash = {
        "title" => title,
        "date" => date.strftime("%d/%m/%Y"),
        "notes" => "",
        "bunting" => bunting,
    }
    if substitute
      bank_holiday_hash["notes"] = "common.substitute_day"
    end
    bank_holidays << bank_holiday_hash
  end

  def new_years_day(second_january_off = false)
    date = Date.new(year, 1, 1)
    new_date = if second_january_off
                 substitute_day_next_day_off(date)
               else
                 substitute_day(date)
               end
    add_bank_holiday("bank_holidays.new_year", new_date, new_date != date)
  end

  def new_years_day_second_january_off
    new_years_day(true)
  end

  def second_january
    date = Date.new(year, 1, 2)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.2nd_january", new_date, new_date != date)
  end

  def st_patricks
    date = Date.new(year, 3, 17)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.st_patrick", new_date, new_date != date)
  end

  def good_friday
    date = easter - 2
    add_bank_holiday("bank_holidays.good_friday", date, false, false)
  end

  def easter_monday
    date = easter + 1
    add_bank_holiday("bank_holidays.easter_monday", date)
  end

  def early_may
    date = first_monday_of_month(year, 5)
    add_bank_holiday("bank_holidays.early_may", date)
  end

  def spring
    date = last_monday_of_month(year, 5)
    add_bank_holiday("bank_holidays.spring", date)
  end

  def battle_boyne
    date = Date.new(year, 7, 12)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.battle_boyne", new_date, new_date != date, false)
  end

  def first_monday_august
    date = first_monday_of_month(year, 8)
    add_bank_holiday("bank_holidays.summer", date)
  end

  def last_monday_august
    date = last_monday_of_month(year, 8)
    add_bank_holiday("bank_holidays.late_august", date)
  end

  def st_andrews
    date = Date.new(year, 11, 30)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.st_andrew", new_date, new_date != date)
  end

  def christmas
    date = Date.new(year, 12, 25)
    new_date = substitute_day_next_day_off(date)
    add_bank_holiday("bank_holidays.christmas", new_date, new_date != date)
  end

  def boxing_day
    date = Date.new(year, 12, 26)
    new_date = substitute_day(date)
    add_bank_holiday("bank_holidays.boxing_day", new_date, new_date != date)
  end

  # Date utilities

  def first_monday_of_month(year, month)
    Date.new(year, month, 1).upto(Date.new(year, month, -1)).find(&:monday?)
  end

  def last_monday_of_month(year, month)
    Date.new(year, month, -1).downto(0).find(&:monday?)
  end

  # The following code comes from:
  # https://github.com/alexdunae/holidays
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
    if date.saturday?
      date += 3
    elsif date.sunday?
      date += 2
    end
    date
  end
end
