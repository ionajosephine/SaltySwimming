class Station 
  attr_accessor :name, :location, :id

  def initialize(name:, location:, id:)
    self.name = name
    self.location = location
    self.id = id
  end
end


