require "gds_api/helpers"

class ApplicationController < ActionController::Base
  include Slimmer::Template

  protect_from_forgery with: :exception

  rescue_from GdsApi::TimedOutException, with: :error_503

  slimmer_template 'wrapper'

  before_action :set_cors_headers, if: :json_request?

protected

  def error_503(e); error(503, e); end

  def error(status_code, exception = nil)
    if exception && defined? GovukError
      GovukError.notify exception
    end
    render status: status_code, text: "#{status_code} error"
  end

  def set_expiry(age = 60.minutes)
    expires_in age, public: true unless Rails.env.development?
  end

  def set_cors_headers
    # Calendars only does GET requests, so it's safe to allow CORS for all
    # requests.
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def json_request?
    request.format.symbol == :json
  end
end
