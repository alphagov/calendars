# encoding: utf-8
require_relative '../integration_test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  context "GET /calendars/<calendar>.json" do
    should "contain calendar data with individual calendar" do
      get "/bank-holidays/england-and-wales-2012.json"

      output = {
        "events" => [
          {"date"=>"2012-01-02", "notes"=>"Substitute day", "title"=>"New Year’s Day", "bunting"=>"true"},
          {"date"=>"2012-06-04", "notes"=>"Substitute day", "title"=>"Spring bank holiday", "bunting"=>"true"},
          {"date"=>"2012-06-05", "notes"=>"Extra bank holiday", "title"=>"Queen’s Diamond Jubilee", "bunting"=>"true"},
          {"date"=>"2012-08-27", "notes"=>"", "title"=>"Summer bank holiday", "bunting"=>"true"},
          {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
        ],
        "division"=>"england-and-wales",
        "year"=>"2012"
      }

      assert_equal output, JSON.parse(@response.body)
    end

    should "contain calendar with division" do
      get "/bank-holidays/england-and-wales.json"

      output = {
        "division" => "england-and-wales",
        "events" => [
          {"date"=>"2012-01-02", "notes"=>"Substitute day", "title"=>"New Year’s Day", "bunting"=>"true"},
          {"date"=>"2012-06-04", "notes"=>"Substitute day", "title"=>"Spring bank holiday", "bunting"=>"true"},
          {"date"=>"2012-06-05", "notes"=>"Extra bank holiday", "title"=>"Queen’s Diamond Jubilee", "bunting"=>"true"},
          {"date"=>"2012-08-27", "notes"=>"", "title"=>"Summer bank holiday", "bunting"=>"true"},
          {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
          {"date"=>"2013-01-01", "notes"=>"", "title"=>"New Year’s Day", "bunting"=>"true"},
          {"date"=>"2013-03-29", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
          {"date"=>"2013-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2013-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
        ]
      }

      assert_equal output, JSON.parse(@response.body)
    end
  end
end
