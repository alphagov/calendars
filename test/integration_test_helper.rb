require_relative 'test_helper'
require 'capybara/rails'
require 'gds_api/test_helpers/content_api'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::ContentApi

  setup do
    stub_content_api_default_artefact
  end
end
