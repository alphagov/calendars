class Calendar
  class Division
    SLUGS = {
      "england-and-wales" => "england-and-wales_slug",
      "cymru-a-lloegr" => "england-and-wales_slug",
      "northern-ireland" => "northern-ireland_slug",
      "gogledd-iwerddon" => "northern-ireland_slug",
      "scotland" => "scotland_slug",
      "yr-alban" => "scotland_slug",
    }.freeze

    attr_reader :slug, :title

    def initialize(slug, data = {})
      @slug = data["slug"] || slug
      @title = data.delete("title") || slug.underscore.humanize
      @data = data
    end

    def to_param
      I18n.t(slug)
    end

    def years
      @years ||= @data.map { |year, events| Year.new(year, self, events) if year.match?(/\A\d{4}\z/) }.compact
    end

    def year(name)
      yr = years.find { |y| y.to_s == name }
      raise CalendarNotFound unless yr

      yr
    end

    def events
      years.map(&:events).flatten(1)
    end

    def upcoming_event
      @upcoming_event ||= begin
        year = years.find(&:upcoming_event)
        year.upcoming_event if year
      end
    end

    def upcoming_events_by_year
      years.each_with_object({}) do |year, results|
        results[year] = year.upcoming_events if year.upcoming_events.any?
      end
    end

    def past_events_by_year
      years.reverse.each_with_object({}) do |year, results|
        results[year] = year.past_events.reverse if year.past_events.any?
      end
    end

    def show_bunting?
      upcoming_event && upcoming_event.date.today? && upcoming_event.bunting
    end

    def as_json(_options = {})
      {
        "division" => I18n.t(@slug),
        "events" => events,
      }
    end
  end
end
