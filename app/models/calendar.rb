class Calendar

  REPOSITORY_PATH = Rails.env.test? ? "test/fixtures/data" : "lib/data"

  class CalendarNotFound < StandardError
  end

  def self.find(slug)
    json_file = Rails.root.join(REPOSITORY_PATH, "#{slug}.json")
    if File.exists?(json_file)
      data = JSON.parse(File.read(json_file))
      self.new(slug, data)
    else
      raise CalendarNotFound
    end
  end

  attr_reader :slug, :title, :description
  alias :to_param :slug

  def initialize(slug, data = {})
    @slug = slug
    @data = data
    @title = data["title"]
    @description = data["description"]
  end

  def divisions
    @divisions ||= @data["divisions"].map {|slug, data| Division.new(slug, data) }
  end

  def division(slug)
    div = divisions.find {|d| d.slug == slug }
    raise CalendarNotFound unless div
    div
  end

  def events
    divisions.map(&:events).flatten(1)
  end

  def as_json(options = nil)
    # TODO: review this representation
    # This is kinda messy because the top-level JSON representation is inconsistent
    # with the lower level representations
    divisions.each_with_object({}) do |division, hash|
      hash[division.slug] = {
        "division" => division.slug,
        "calendars" => division.years.each_with_object({}) do |year, years|
          years[year.to_s] = year
        end
      }
    end
  end
end
