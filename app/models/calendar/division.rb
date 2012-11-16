class Calendar
  class Division
    attr_reader :slug, :title
    alias :to_param :slug

    def initialize(slug, data = {})
      @slug = slug
      @title = data.delete("title") || slug.underscore.humanize
      @data = data
    end

    def years
      @years ||= @data.map { |year, events| Year.new(year, events) if year =~ /\A\d{4}\z/ }.compact
    end
  end
end
