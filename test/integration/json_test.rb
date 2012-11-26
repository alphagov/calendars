# encoding: utf-8
require_relative '../integration_test_helper'

class JSONTest < ActionDispatch::IntegrationTest
  context "GET /calendars/<calendar>.json" do
    should "contain calendar data with individual calendar" do
      get "/bank-holidays/england-and-wales-2012.json"

      expected = {
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

      actual = JSON.parse(@response.body)
      assert_equal expected["events"], actual["events"]
      assert_equal expected["division"], actual["division"]
      assert_equal expected["year"], actual["year"]
    end

    should "contain calendar with division" do
      get "/bank-holidays/england-and-wales.json"

      expected = {
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

      actual = JSON.parse(@response.body)
      assert_equal expected["events"], actual["events"]
      assert_equal expected["division"], actual["division"]
    end

    should "have the full calendar json view" do
      get "/bank-holidays.json"

      expected = {
        "england-and-wales" => {
          "division" => "england-and-wales",
          "calendars" => {
            "2012" => {
              "year" => "2012",
              "division" => "england-and-wales",
              "events" => [
                {"date"=>"2012-01-02", "notes"=>"Substitute day", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2012-06-04", "notes"=>"Substitute day", "title"=>"Spring bank holiday", "bunting"=>"true"},
                {"date"=>"2012-06-05", "notes"=>"Extra bank holiday", "title"=>"Queen’s Diamond Jubilee", "bunting"=>"true"},
                {"date"=>"2012-08-27", "notes"=>"", "title"=>"Summer bank holiday", "bunting"=>"true"},
                {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
            "2013" => {
              "year" => "2013",
              "division" => "england-and-wales",
              "events" => [
                {"date"=>"2013-01-01", "notes"=>"", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2013-03-29", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
                {"date"=>"2013-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2013-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
          }
        },
        "scotland" => {
          "division" => "scotland",
          "calendars" => {
            "2012" => {
              "year" => "2012",
              "division" => "scotland",
              "events" => [
                {"date"=>"2012-01-02", "notes"=>"", "title"=>"2nd January", "bunting"=>"true"},
                {"date"=>"2012-01-03", "notes"=>"Substitute day", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2012-06-04", "notes"=>"Substitute day", "title"=>"Spring bank holiday", "bunting"=>"true"},
                {"date"=>"2012-06-05", "notes"=>"Extra bank holiday", "title"=>"Queen’s Diamond Jubilee", "bunting"=>"true"},
                {"date"=>"2012-08-06", "notes"=>"", "title"=>"Summer bank holiday", "bunting"=>"true"},
                {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
            "2013" => {
              "year" => "2013",
              "division" => "scotland",
              "events" => [
                {"date"=>"2013-01-01", "notes"=>"", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2013-03-29", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
                {"date"=>"2013-12-02", "notes"=>"Substitute day", "title"=>"St Andrew’s Day", "bunting"=>"true"},
                {"date"=>"2013-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2013-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
          }
        },
        "northern-ireland" => {
          "division" => "northern-ireland",
          "calendars" => {
            "2012" => {
              "year" => "2012",
              "division" => "northern-ireland",
              "events" => [
                {"date"=>"2012-01-02", "notes"=>"Substitute day", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2012-03-19", "notes"=>"Substitute day", "title"=>"St Patrick’s Day", "bunting"=>"true"},
                {"date"=>"2012-06-04", "notes"=>"", "title"=>"Spring bank holiday", "bunting"=>"true"},
                {"date"=>"2012-06-05", "notes"=>"Extra bank holiday", "title"=>"Queen’s Diamond Jubilee", "bunting"=>"true"},
                {"date"=>"2012-08-27", "notes"=>"", "title"=>"Summer bank holiday", "bunting"=>"true"},
                {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
            "2013" => {
              "year" => "2013",
              "division" => "northern-ireland",
              "events" => [
                {"date"=>"2013-01-01", "notes"=>"", "title"=>"New Year’s Day", "bunting"=>"true"},
                {"date"=>"2013-03-29", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
                {"date"=>"2013-07-12", "notes"=>"", "title"=>"Battle of the Boyne (Orangemen’s Day)", "bunting"=>"false"},
                {"date"=>"2013-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
                {"date"=>"2013-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"},
              ]
            },
          }
        },
      }

      assert_equal expected, JSON.parse(@response.body)
    end

    should "have redirects for old 'ni' division" do
      get "/bank-holidays/ni.json"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland.json", response.location

      get "/bank-holidays/ni-2012.json"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland-2012.json", response.location

      get "/bank-holidays/ni-2013.json"
      assert_equal 301, response.status
      assert_equal "http://www.example.com/bank-holidays/northern-ireland-2013.json", response.location
    end
  end
end
