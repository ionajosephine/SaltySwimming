class AddConditionsToSpots < ActiveRecord::Migration[7.0]
  def change
    add_column :spots, :condition, :integer
  end
end
