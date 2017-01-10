require 'ostruct'

class RegisterableCalendar
  extend Forwardable

  attr_accessor :calendar, :slug

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
end
