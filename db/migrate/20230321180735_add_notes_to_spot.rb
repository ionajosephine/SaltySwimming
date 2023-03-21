class AddNotesToSpot < ActiveRecord::Migration[7.0]
  def change
    add_column :spots, :notes, :string
  end
end
