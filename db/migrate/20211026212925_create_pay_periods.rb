class CreatePayPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :pay_periods do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
