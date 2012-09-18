require 'ostruct'

# Takes a path and produces a calendar object for registering in
# panopticon
class RegisterableCalendar
  extend Forwardable

  attr_accessor :calendar, :slug, :live

  def_delegators :@calendar, :title, :need_id, :description, :indexable_content

  def initialize(path)
    details = JSON.parse(File.read(path))
    @calendar = OpenStruct.new(details)
    @slug = File.basename(path, '.json')
  end

  def state
    'live'
  end

  def paths
    ["#{@slug}.json"]
  end

  def prefixes
    [@slug]
  end
end
