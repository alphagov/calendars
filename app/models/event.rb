class Event
  attr_accessor :title, :date, :notes, :bunting

  def initialize(attributes)
    self.title = attributes[:title]
    self.date  = attributes[:date]
    self.notes = attributes[:notes]
    self.bunting = attributes[:bunting]
  end
end
