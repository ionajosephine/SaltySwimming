class CreateSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :spots do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
