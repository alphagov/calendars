require 'ics_renderer'

class CalendarController < ApplicationController
  before_action :set_locale
  before_action :load_calendar

  rescue_from Calendar::CalendarNotFound, with: :simple_404

  def calendar
    set_expiry

    respond_to do |format|
      format.html do
        @content_item = Services.content_store.content_item("/#{scope}").to_hash
        # Remove the organisations from the content item - this will prevent the
        # govuk:analytics:organisations meta tag from being generated until there is
        # a better way of doing this.
        if @content_item["links"]
          @content_item["links"].delete("organisations")
        end

        @navigation_helpers = GovukNavigationHelpers::NavigationHelper.new(@content_item)
        section_name = @content_item.dig("links", "parent", 0, "links", "parent", 0, "title")
        if section_name
          @meta_section = section_name.downcase
        end

        render scope.tr('-', '_')
      end
      format.json do
        render json: @calendar
      end
    end
  end

  def division
    handle_bank_holiday_ics_calendars
    division = @calendar.division(params[:division])
    set_expiry 1.day

    respond_to do |format|
      format.json { render json: division }
      format.ics { render plain: ICSRenderer.new(division.events, request.path).render }
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
      division_slug = Calendar::Division::SLUGS[params[:division]]

      params[:division] = "common.nations.#{division_slug}"
    end
  end
end
