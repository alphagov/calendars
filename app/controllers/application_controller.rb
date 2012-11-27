require "slimmer/headers"

class ApplicationController < ActionController::Base
  include Slimmer::Headers
  protect_from_forgery

  protected

  def set_expiry(age = 60.minutes)
    expires_in age, :public => true unless Rails.env.development?
  end
end
