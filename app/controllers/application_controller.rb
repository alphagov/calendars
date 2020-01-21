class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::TimedOutException, with: :error_503

  before_action :set_cors_headers, if: :json_request?

  if ENV["BASIC_AUTH_USERNAME"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

protected

  def error_403
    render status: :forbidden, plain: "403 forbidden"
  end

  def error_503(exception)
    GovukError.notify(exception) if exception && defined? GovukError
    render status: :service_unavailable, plain: "503 service unavailable"
  end

  def set_expiry(age = 60.minutes)
    expires_in age, public: true unless Rails.env.development?
  end

  def set_cors_headers
    # Calendars only does GET requests, so it's safe to allow CORS for all
    # requests.
    headers["Access-Control-Allow-Origin"] = "*"
  end

  def json_request?
    request.format.symbol == :json
  end
end
