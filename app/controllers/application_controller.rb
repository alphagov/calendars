require "slimmer/headers"
require "gds_api/helpers"

class ApplicationController < ActionController::Base
  include Slimmer::Headers
  protect_from_forgery

  rescue_from GdsApi::TimedOutException, :with => :error_503

  protected

  def error_503(e); error(503, e); end

  def error(status_code, exception = nil)
    if exception and Rails.application.config.middleware.detect{ |x| x.klass == ExceptionNotifier }
      ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    end
    render status: status_code, text: "#{status_code} error"
  end

  def set_expiry(age = 60.minutes)
    expires_in age, :public => true unless Rails.env.development?
  end
end
