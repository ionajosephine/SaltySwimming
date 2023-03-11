class Tide
  attr_accessor :event, :date_time, :height

  def initialize(event:, date_time:, height:)
    self.event = event
    self.date_time = date_time
    self.height = height
  end
end



