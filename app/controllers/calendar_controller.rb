require 'gds_api/helpers'
require 'ics_renderer'

class CalendarController < ApplicationController
  include GdsApi::Helpers

  before_filter :set_locale
  before_filter :load_calendar
 
  rescue_from Calendar::CalendarNotFound, with: :simple_404

  def calendar
    set_expiry

    respond_to do |format|
      format.html do
        @artefact = content_api.artefact(params[:scope])

        I18n.locale = @artefact.details.language if @artefact
        set_slimmer_artefact(@artefact)
        set_slimmer_headers :format => "calendar"
        render scope.gsub('-', '_')
      end
      format.json do
        render :json => @calendar
      end
    end
  end

  def division
    handle_bank_holiday_ics_calendars
    division = @calendar.division(params[:division])
    set_expiry 1.day

    respond_to do |format|
      format.json { render :json => division }
      format.ics { render :text => ICSRenderer.new(division.events, request.path).render }
      format.all { simple_404 }
    end
  end

private

  def scope
    if params[:scope] == "gwyliau-banc"
      "bank-holidays"
    else
      params[:scope]
    end
  end

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def load_calendar
    simple_404 unless params[:scope] =~ /\A[a-z-]+\z/
    @calendar = Calendar.find(scope)
  end

  def simple_404
    head 404
  end

  def handle_bank_holiday_ics_calendars
    if scope == "bank-holidays"
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      translations = I18n.backend.send(:translations)
      division_key = translations[I18n.locale][:common][:nations].key(params[:division]).to_s
      params[:division] = "common.nations."+division_key
    end
  end
end
