class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :admiralty_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
