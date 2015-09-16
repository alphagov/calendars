require 'ostruct'

# Takes a path and produces a calendar object for registering in
# panopticon
class RegisterableCalendar
  extend Forwardable

  attr_accessor :calendar, :slug, :live

  def_delegators :@calendar, :indexable_content, :content_id

  def initialize(path)
    details = JSON.parse(File.read(path))
    @calendar = OpenStruct.new(details)
    @slug = File.basename(path, '.json')
  end

  def title
    I18n.t(@calendar.title)
  end

  def description
    I18n.t(@calendar.description)
  end

  def state
    'live'
  end

  def need_ids
    [@calendar.need_id.to_s]
  end

  def paths
    ["/#{@slug}.json"]
  end

  def prefixes
    ["/#{@slug}"]
  end
end
