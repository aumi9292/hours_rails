# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

employees = ['Austin Miller', 'Frito Lays', 'Jimmy Johns', 'Lisa Loops']

employees.each do |e_full_name|
  Employee.create(full_name: e_full_name)
end

pay_periods = [
 ['09/01/2021','09/14/2021'],
 ['09/15/2021','09/30/2021'],
 ['10/01/2021','10/14/2021'],
 ['10/15/2021','10/31/2021'],
 ['11/01/2021','11/14/2021'],
 ['11/15/2021','11/30/2021'],
 ['12/01/2021','12/14/2021'],
 ['12/15/2021','12/31/2021'],
 ['01/01/2022','01/14/2022'],
 ['01/15/2022','01/31/2022'],
]

pay_periods.each do |start_date, end_date|
  PayPeriod.create(start_date: start_date, end_date: end_date)
end

date_hours = [
  ['10/26/21', 4, 1, 4],
  ['10/27/21', 1, 2, 4],
  ['11/08/21', 1.5, 3, 5],
]

date_hours.each do |date, hours, employee_id, pay_period_id|
  DateHour.create(
    date: date, 
    hours: hours, 
    employee_id: employee_id, 
    pay_period_id: pay_period_id
  )
end
