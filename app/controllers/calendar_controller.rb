require 'gds_api/helpers'

class CalendarController < ApplicationController
  include GdsApi::Helpers

  before_filter :find_scope, :only => [:index, :show]
  before_filter :find_calendar, :only => :show

  before_filter :validate_scope, :only => [:calendar]
  before_filter :set_expiry, :only => [:calendar]

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
            @artefact = content_api.artefact(@scope)
            set_slimmer_artefact(@artefact)
            render "show_#{@scope_view_name}"
          end
          format.json { @divisions.each {|key, i| @divisions[key].delete(:whole_calendar) }
            render :json => @divisions.to_json }
        end
      end
      set_slimmer_headers(
        format:      "calendar"
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

  def calendar
    @calendar = Calendar.find(params[:scope])

    respond_to do |format|
      format.html do
        @artefact = content_api.artefact(params[:scope])
        set_slimmer_artefact(@artefact)
        set_slimmer_headers :format => "calendar"

        render params[:scope].gsub('-', '_')
      end
      format.json do
        render :json => @calendar.to_json
      end
    end
  end

private

  def validate_scope
    simple_404 unless params[:scope] =~ /\A[a-z-]+\z/
  end

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
