class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :station, optional: true
  has_many :swim_logs
  validates :latitude, :longitude, :name, presence: true

  enum condition: [:high_water, :low_water, :other]

  before_save :set_station

  private

  def set_station
    # The `.near` method comes from the geocoder gem
    self.station = Station.near([latitude, longitude]).first
  end
end
