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

        set_locale(@artefact)
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
    target = @calendar.division(params[:division])
    if params[:year]
      target = target.year(params[:year])
    end

    set_expiry 1.day

    respond_to do |format|
      format.json { render :json => target }
      format.ics { render :text => ICSRenderer.new(target.events, request.path).render }
      format.all { simple_404 }
    end
  end

private

  def load_calendar
    simple_404 unless params[:scope] =~ /\A[a-z-]+\z/
    @calendar = Calendar.find(params[:scope])
  end

  def simple_404
    head 404
  end

  def set_locale(artefact)
    if artefact and artefact["details"]
      I18n.locale = artefact["details"]["language"]
    end
  end
end
