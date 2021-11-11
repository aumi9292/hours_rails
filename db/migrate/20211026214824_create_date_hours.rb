class CreateDateHours < ActiveRecord::Migration[6.0]
  def change
    create_table :date_hours do |t|
      t.date :date, null: false
      t.decimal :hours, precision: 5, scale: 4, default: 0.0000
      t.string :day, null: false
      t.references :employee, null: false, foreign_key: true
      t.references :pay_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end