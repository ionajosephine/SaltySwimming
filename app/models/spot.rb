class Spot < ApplicationRecord
  belongs_to :user
  validates :latitude, :longitude, :name, presence: true
end
