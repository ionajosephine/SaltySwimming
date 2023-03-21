class AddStationIdToSpots < ActiveRecord::Migration[7.0]
  def change
    add_reference :spots, :station, null: true, foreign_key: true
  end
end
