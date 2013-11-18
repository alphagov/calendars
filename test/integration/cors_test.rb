require 'integration_test_helper'

class CORSTest < ActionDispatch::IntegrationTest
  setup do
    @resource = calendar_path(scope: 'bank-holidays', format: :json)
  end

  context "when accessing calendars from a recognized origin" do
    setup do
      @headers = {'HTTP_ORIGIN' => 'http://callmeback.justice.gov.uk'}
    end

    should "respond with CORS headers set on a request for a particular resource" do
      get @resource, {}, @headers
      assert_equal 'http://callmeback.justice.gov.uk', response['Access-Control-Allow-Origin']
      assert_equal '', response['Access-Control-Expose-Headers']
      assert_nil response['Access-Control-Allow-Credentials']
      assert_nil response['Access-Control-Allow-Headers']
    end

    should "respond with CORS haeders set on a preflight request" do
      options @resource, {}, @headers
      assert_equal 'http://callmeback.justice.gov.uk', response['Access-Control-Allow-Origin']
      assert_equal 'GET', response['Access-Control-Allow-Methods']
      assert_nil response['Access-Control-Allow-Headers']
      assert_nil response['Access-Control-Allow-Credentials']
      assert_equal '1728000', response['Access-Control-Max-Age']
    end
  end

  context "when accessing calendars from an unrecognized origin" do
    should "not respond with any headers when retrieving a resource" do
      get @resource
      assert_nil response['Access-Control-Allow-Origin']
      assert_nil response['Access-Control-Allow-Methods']
      assert_nil response['Access-Control-Expose-Headers']
      assert_nil response['Access-Control-Allow-Credentials']
    end

    should "not respond with any headers when issuing a preflight request" do
      options @resource, {}, {'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET'}
      assert_nil response['Access-Control-Allow-Origin']
      assert_nil response['Access-Control-Allow-Methods']
      assert_nil response['Access-Control-Allow-Headers']
      assert_nil response['Access-Control-Allow-Credentials']
      assert_nil response['Access-Control-Max-Age']
    end
  end

  def options(path, parameters = nil, headers_or_env = nil)
    integration_session.send(:process, :options, path, parameters, headers_or_env)
  end
end
