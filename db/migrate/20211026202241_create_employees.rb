class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false

      t.timestamps
    end
  end
end
