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

  context "events" do
    setup do
      @divisions = []
      @calendar = Calendar.new('a-calendar')
      @calendar.stubs(:divisions).returns(@divisions)
    end

    should "merge events for all years into single array" do
      @divisions << stub("Division1", :events => [1,2])
      @divisions << stub("Division2", :events => [3,4,5])
      @divisions << stub("Division3", :events => [6,7])

      assert_equal [1,2,3,4,5,6,7], @calendar.events
    end

    should "handle years with no events" do
      @divisions << stub("Division1", :events => [1,2])
      @divisions << stub("Division2", :events => [])
      @divisions << stub("Division3", :events => [6,7])

      assert_equal [1,2,6,7], @calendar.events
    end
  end

  context "attribute accessors" do
    setup do
      @cal = Calendar.new('a-calendar', {
        "title" => "UK bank holidays",
        "description" => "UK bank holidays description",
      })
    end

    should "have an accessor for the title" do
      assert_equal "UK bank holidays", @cal.title
    end

    should "have an accessor for the description" do
      assert_equal "UK bank holidays description", @cal.description
    end
  end

  context "as_json" do
    setup do
      @div1 = stub("Division", :slug => 'division-1', :as_json => "div1 json")
      @div2 = stub("Division", :slug => 'division-2', :as_json => "div2 json")
      @cal = Calendar.new('a-calendar')
      @cal.stubs(:divisions).returns([@div1, @div2])
    end

    should "construct a hash representation of all divisions" do
      expected = {
        "division-1" => "div1 json",
        "division-2" => "div2 json",
      }
      assert_equal expected, @cal.as_json
    end
  end
end
