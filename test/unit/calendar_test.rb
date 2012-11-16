# encoding: utf-8
require_relative '../test_helper'

class CalendarTest < ActiveSupport::TestCase

  context "finding a calendar by slug" do

    should "construct a calendar with the slug and data from the corresponding JSON file" do
      data_from_json = JSON.parse(File.read(Rails.root.join(Calendar::REPOSITORY_PATH, 'single-calendar.json')))
      Calendar.expects(:new).with('single-calendar', data_from_json).returns(:a_calendar)

      cal = Calendar.find('single-calendar')
      assert_equal :a_calendar, cal
    end

    should "raise exception when calendar doesn't exist" do
      assert_raises Calendar::CalendarNotFound do
        Calendar.find('non-existent')
      end
    end
  end

  should "return the slug" do
    assert_equal 'a-slug', Calendar.new('a-slug', {}).slug
  end

  should "return the slug for to_param" do
    assert_equal 'a-slug', Calendar.new('a-slug', {}).to_param
  end

  context "divisions" do
    setup do
      @cal = Calendar.new('a-calendar', {
        "title" => "UK bank holidays",
        "divisions" => {
          "kablooie" => {
            "2012" => [1],
            "2013" => [3],
          },
          "fooey" => {
            "2012" => [1,2],
            "2013" => [3,4],
          },
          "gooey" => {
            "2012" => [2],
            "2013" => [4],
          },
        }
      })
    end

    should "construct a division for each one in the data" do
      Calendar::Division.expects(:new).with("kablooie", {"2012" => [1], "2013" => [3]}).returns(:kablooie)
      Calendar::Division.expects(:new).with("fooey", {"2012" => [1,2], "2013" => [3,4]}).returns(:fooey)
      Calendar::Division.expects(:new).with("gooey", {"2012" => [2], "2013" => [4]}).returns(:gooey)

      assert_equal [:kablooie, :fooey, :gooey], @cal.divisions
    end

    should "cache the constructed instances" do
      first = @cal.divisions
      Calendar::Division.expects(:new).never
      assert_equal first, @cal.divisions
    end

    context "finding a division by slug" do
      should "return the division with the matching slug" do
        div = @cal.division('fooey')
        assert_equal Calendar::Division, div.class
        assert_equal 'Fooey', div.title
      end

      should "raise exception when division doesn't exist" do
        assert_raises Calendar::CalendarNotFound do
          @cal.division('non-existent')
        end
      end
    end
  end

  context "Calendar" do

    should "be able to access all calendars" do
      assert_equal Calendar.all_slugs.size, 5
      assert Calendar.all_slugs.include? '/bank-holidays'
      assert Calendar.all_slugs.include? '/combine-calendar'
      assert Calendar.all_slugs.include? '/multiple-divisions'
      assert Calendar.all_slugs.include? '/single-calendar'
      assert Calendar.all_slugs.include? '/when-do-the-clocks-change'
    end

    should "load calendar item successfully" do
      repository = Calendar::Repository.new("single-calendar")

      @calendar = repository.all_grouped_by_division['england-and-wales'][:calendars]['2011']

      assert_kind_of Calendar, @calendar
      assert_kind_of Event, @calendar.events[0]

      assert_equal @calendar.events.size, 1
      assert_equal @calendar.events[0].title, "New Year's Day"
      assert_equal @calendar.events[0].date, Date.parse('2nd January 2011')
      assert_equal @calendar.events[0].notes, "Substitute day"
    end

    should "throw exception when calendar does not exist" do
      assert_raises Calendar::CalendarNotFound do
        repository = Calendar::Repository.new("calendar-which-doesnt-exist")
      end
    end

    should "throw exception when calendar exists but division doesn't" do
      assert_raises Calendar::CalendarNotFound do
        repository = Calendar.combine("multiple-divisions", "fake-division")
      end
    end

    should "expose calendar need_id" do
      repository = Calendar::Repository.new("single-calendar")
      assert_equal 42, repository.need_id
    end

    should "load individual calendar given division and year" do
      repository = Calendar::Repository.new("multiple-divisions")

      @calendar = repository.find_by_division_and_year( 'england-and-wales', '2011' )

      assert_kind_of Calendar, @calendar

      assert_equal @calendar.division, 'england-and-wales'
      assert_equal @calendar.year, '2011'
      assert_equal @calendar.events.size, 5

      assert_equal @calendar.events[2].title, "Royal wedding"
      assert_equal @calendar.events[2].date, Date.parse('29th April 2011')
      assert_equal @calendar.events[2].notes, ""
    end

    should "combine multiple calendars" do
      repository = Calendar::Repository.new("combine-calendar")

      @calendars = repository.all_grouped_by_division
      @combined = Calendar.combine(@calendars, 'united-kingdom')

      assert_equal @combined.events.size, 4
    end

    should "give correct upcoming event" do
      repository = Calendar::Repository.new("multiple-divisions")
      @calendar = repository.find_by_division_and_year( 'england-and-wales', '2011' )

      Timecop.freeze(Date.parse('1 April 2011')) do
        assert_equal @calendar.upcoming_event.title, "Good Friday"
      end
    end

    should "give correct upcoming event between multiple calendars" do
      repository = Calendar::Repository.new("multiple-divisions")
      @calendar = repository.all_grouped_by_division['england-and-wales'][:whole_calendar]

      Timecop.freeze(Date.parse('1st January 2012')) do
        assert_equal "New Year's Day", @calendar.upcoming_event.title
      end
    end

    should "be able to check if an event is today" do
      repository = Calendar::Repository.new("multiple-divisions")
      @calendar = repository.find_by_division_and_year( 'england-and-wales', '2011' )

      Timecop.freeze(Date.parse('22 April 2011')) do
        assert @calendar.event_today?
      end

      Timecop.freeze(Date.parse('30 April 2011')) do
        assert !@calendar.event_today?
      end
    end

    should "only show bunting if allowed" do
      repository = Calendar::Repository.new("multiple-divisions")
      @calendar = repository.find_by_division_and_year("england-and-wales", "2011")

      Timecop.freeze(Date.parse("3rd January 2011")) do
        assert_equal true, @calendar.bunting?
      end

      Timecop.freeze(Date.parse("31st July 2011")) do
        assert_equal false, @calendar.bunting?
      end
    end
  end
end
