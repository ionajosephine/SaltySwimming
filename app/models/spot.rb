class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :station, optional: true
  validates :latitude, :longitude, :name, presence: true

  before_save :set_station

  private

  def set_station
    # The `.near` method comes from the geocoder gem
    self.station = Station.near([latitude, longitude]).first
  end
end
