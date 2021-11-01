# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_26_214824) do

  create_table "date_hours", force: :cascade do |t|
    t.date "date"
    t.decimal "hours", precision: 5, scale: 4, default: "0.0"
    t.string "day"
    t.integer "employee_id", null: false
    t.integer "pay_period_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_date_hours_on_employee_id"
    t.index ["pay_period_id"], name: "index_date_hours_on_pay_period_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "full_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pay_periods", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "date_hours", "employees"
  add_foreign_key "date_hours", "pay_periods"
end
