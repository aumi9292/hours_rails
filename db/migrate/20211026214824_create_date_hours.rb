class CreateDateHours < ActiveRecord::Migration[6.0]
  def change
    create_table :date_hours do |t|
      t.date :date
      t.decimal :hours, precision: 5, scale: 4
      t.string :day
      t.references :employee, null: false, foreign_key: true
      t.references :pay_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
