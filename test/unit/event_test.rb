# encoding: utf-8

require_relative '../test_helper'

class EventTest < ActiveSupport::TestCase
  context "construction" do
    should "parse a date given as a string" do
      e = Calendar::Event.new("date" => "2012-02-04")
      assert_equal Date.civil(2012, 2, 4), e.date
    end

    should "allow construction with dates as well as string dates" do
      e = Calendar::Event.new("date" => Date.civil(2012, 2, 4))
      assert_equal Date.civil(2012, 2, 4), e.date
    end
  end
end
