require 'test_helper'
require 'capybara/rails'
require 'gds_api/test_helpers/panopticon'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::Panopticon

  setup do
    stub_panopticon_default_artefact
  end
end
