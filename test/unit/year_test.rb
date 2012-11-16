# encoding: utf-8
require_relative '../test_helper'

class YearTest < ActiveSupport::TestCase

  should "return the year string for to_s" do
    assert_equal "2012", Calendar::Year.new("2012", []).to_s
  end

  context "events" do
    setup do
      @y = Calendar::Year.new("1234", [
        {"title" => "foo", "date" => "02/01/2012"},
        {"title" => "bar", "date" => "27/08/2012"},
      ])
    end

    should "build an openstruct for each event in the data" do
      foo = OpenStruct.new("title" => "foo", "date" => Date.civil(2012, 1, 2))
      bar = OpenStruct.new("title" => "bar", "date" => Date.civil(2012, 8, 27))

      assert_equal [foo, bar], @y.events
    end

    should "cache the constructed instances" do
      first = @y.events
      OpenStruct.expects(:new).never
      assert_equal first, @y.events
    end
  end

end
