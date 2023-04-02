class CreateSwimLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :swim_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spot, foreign_key: true, optional: true
      t.date :swim_date
      t.time :swim_time
      t.string :notes

      t.timestamps
    end
  end
end
