require 'gds_api/helpers'
require 'ics_renderer'

class CalendarController < ApplicationController
  include GdsApi::Helpers

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
        render params[:scope].gsub('-', '_')
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

  def load_calendar
    if params[:scope] == "gwyliau-banc"
      I18n.locale = :cy
      params[:scope] = "bank-holidays"
    end
    simple_404 unless params[:scope] =~ /\A[a-z-]+\z/
    @calendar = Calendar.find(params[:scope])
  end

  def simple_404
    head 404
  end

  def handle_bank_holiday_ics_calendars
    if params[:scope] == "bank-holidays"
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      translations = I18n.backend.send(:translations)
      english_nation_translations = translations[:en][:common][:nations]
      division_key = english_nation_translations.key(params[:division]).to_s
      if division_key.empty?
        welsh_nation_translations = translations[:cy][:common][:nations]
        division_key = welsh_nation_translations.key(params[:division]).to_s
        I18n.locale = :cy
      end
      params[:division] = "common.nations."+division_key
    end
  end
end
