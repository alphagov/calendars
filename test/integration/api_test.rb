require 'integration_test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  context "GET /calendars/<calendar>.json" do
    should "contain calendar data with individual calendar" do
      get "/bank-holidays/england-and-wales-2011.json"

      output = {
        "events" => [
          {"date"=>"2011-01-03", "notes"=>"Substitute day", "title"=>"New Year's Day", "bunting"=>"true"},
          {"date"=>"2011-04-22", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
          {"date"=>"2011-04-29", "notes"=>"", "title"=>"Royal wedding", "bunting"=>"true"},
          {"date"=>"2011-12-26", "notes"=>"Substitute day", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2011-12-27", "notes"=>"Substitute day", "title"=>"Boxing Day", "bunting"=>"true"}
        ],
        "division"=>"england-and-wales",
        "year"=>"2011"
      }

      assert_equal output, JSON.parse(@response.body)
    end

    should "contain calendar with division" do
      get "/bank-holidays/england-and-wales.json"

      output = {
        "division" => "england-and-wales",
        "events" => [
          {"date"=>"2011-01-03", "notes"=>"Substitute day", "title"=>"New Year's Day", "bunting"=>"true"},
          {"date"=>"2011-04-22", "notes"=>"", "title"=>"Good Friday", "bunting"=>"true"},
          {"date"=>"2011-04-29", "notes"=>"", "title"=>"Royal wedding", "bunting"=>"true"},
          {"date"=>"2011-12-26", "notes"=>"Substitute day", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2011-12-27", "notes"=>"Substitute day", "title"=>"Boxing Day", "bunting"=>"true"},
          {"date"=>"2012-01-02", "notes"=>"Substitute day", "title"=>"New Year's Day", "bunting"=>"true"},
          {"date"=>"2012-05-07", "notes"=>"", "title"=>"Early May Bank Holiday", "bunting"=>"true"},
          {"date"=>"2012-12-25", "notes"=>"", "title"=>"Christmas Day", "bunting"=>"true"},
          {"date"=>"2012-12-26", "notes"=>"", "title"=>"Boxing Day", "bunting"=>"true"}
        ]
      }

      assert_equal output, JSON.parse(@response.body)
    end
  end
end