# encoding: utf-8
require_relative '../test_helper'

class YearTest < ActiveSupport::TestCase
  should "return the year string for to_s" do
    assert_equal "2012", Calendar::Year.new("2012", :a_division, []).to_s
  end

  context "events" do
    setup do
      @y = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
      ])
    end

    should "build an event for each event in the data" do
      foo = Calendar::Event.new("title" => "foo", "date" => Date.civil(2012, 1, 2))
      bar = Calendar::Event.new("title" => "bar", "date" => Date.civil(2012, 8, 27))

      assert_equal [foo, bar], @y.events
    end

    should "cache the constructed instances" do
      first = @y.events
      Calendar::Event.expects(:new).never
      assert_equal first, @y.events
    end
  end

  context "upcoming_event" do
    should "return nil with no events" do
      y = Calendar::Year.new("1234", :a_division, [])
      assert_nil y.upcoming_event
    end

    should "return nil with no future events" do
      y = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
      ])
      assert_nil y.upcoming_event
    end

    should "return the first event that's in the future" do
      y = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
        { "title" => "baz", "date" => "16/10/2012" },
      ])
      Timecop.travel(Date.parse("2012-03-24")) do
        assert_equal "bar", y.upcoming_event.title
      end
    end

    should "count an event today as a future event" do
      y = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
        { "title" => "baz", "date" => "16/10/2012" },
      ])
      Timecop.travel(Date.parse("2012-08-27")) do
        assert_equal "bar", y.upcoming_event.title
      end
    end

    should "cache the event" do
      y = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
        { "title" => "baz", "date" => "16/10/2012" },
      ])
      Timecop.travel(Date.parse("2012-03-24")) do
        y.upcoming_event
        y.expects(:events).never
        assert_equal "bar", y.upcoming_event.title
      end
    end
  end

  context "upcoming_events" do
    setup do
      @year = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
        { "title" => "baz", "date" => "16/10/2012" },
      ])
    end

    should "return all future events including today" do
      Timecop.travel("2012-08-27") do
        assert_equal %w(bar baz), @year.upcoming_events.map(&:title)
      end
    end

    should "cache the result" do
      @year.upcoming_events
      @year.expects(:events).never
      @year.upcoming_events
    end
  end

  context "past_events" do
    setup do
      @year = Calendar::Year.new("1234", :a_division, [
        { "title" => "foo", "date" => "02/01/2012" },
        { "title" => "bar", "date" => "27/08/2012" },
        { "title" => "baz", "date" => "16/10/2012" },
      ])
    end

    should "return all past events excluding today" do
      Timecop.travel("2012-08-27") do
        assert_equal ["foo"], @year.past_events.map(&:title)
      end
    end

    should "cache the result" do
      @year.past_events
      @year.expects(:events).never
      @year.past_events
    end
  end
end
