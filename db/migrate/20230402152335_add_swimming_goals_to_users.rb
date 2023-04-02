class AddSwimmingGoalsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :weekly_swims, :integer
    add_column :users, :monthly_swims, :integer
  end
end
