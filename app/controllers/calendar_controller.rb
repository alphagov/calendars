require 'gds_api/helpers'

class CalendarController < ApplicationController
  include GdsApi::Helpers

  before_filter :find_scope
  before_filter :find_calendar, :only => :show

  rescue_from Calendar::CalendarNotFound, with: :simple_404

  def index
    expires_in 60.minute, :public => true unless Rails.env.development?
    if @scope
      @divisions = @repository.all_grouped_by_division
      respond_to do |format|
        if params[:division]
          format.json { render :json => @repository.combined_calendar_for_division(params[:division]).to_json }
          format.ics  { render :text => @repository.combined_calendar_for_division(params[:division]).to_ics }
          format.html { simple_404 }
        else
          format.html do
            @artefact = fetch_artefact(:slug => @scope)
            set_slimmer_artefact(@artefact)
            render "show_#{@scope_view_name}"
          end
          format.json { @divisions.each {|key, i| @divisions[key].delete(:whole_calendar) }
            render :json => @divisions.to_json }
        end
      end
      set_slimmer_headers(
        format:      "calendar",
        proposition: "citizen",
        need_id:     @repository.need_id,
        section:     @repository.section
      )
    else
      simple_404
    end
  end

  def show
    expires_in 24.hours, :public => true unless Rails.env.development?
    if @scope and @calendar
      respond_to do |format|
        format.json { render :json => @calendar.to_json }
        format.ics { render :text => @calendar.to_ics }
      end
    else
      simple_404
    end
  end

private

  def find_scope
    @scope = params[:scope]
    @scope_view_name = @scope.gsub('-','_')
    @repository = Calendar::Repository.new(@scope)
  rescue ArgumentError
    nil
  end

  def find_calendar
    @calendar = @repository.find_by_division_and_year(params[:division], params[:year])
  rescue ArgumentError
    nil
  end

  def simple_404
    head 404
  end
end
