employees = [
  {full_name: 'Austin Miller'}, 
  {full_name: 'Frito Lays'}, 
  {full_name: 'Jimmy Johns'}, 
  {full_name: 'Lisa Loops'}
]

pay_periods = [
 {start_date: '2021-09-01', end_date: '2021-09-14'},
 {start_date: '2021-09-15', end_date: '2021-09-30'},
 {start_date: '2021-10-01', end_date: '2021-10-14'},
 {start_date: '2021-10-15', end_date: '2021-10-31'},
 {start_date: '2021-11-01', end_date: '2021-11-14'},
 {start_date: '2021-11-15', end_date: '2021-11-30'},
 {start_date: '2021-12-01', end_date: '2021-12-14'},
 {start_date: '2021-12-15', end_date: '2021-12-31'},
 {start_date: '2022-01-01', end_date: '2022-01-14'},
 {start_date: '2022-01-15', end_date: '2022-01-31'},
]

date_hours = [
  {date: '2021-10-26', hours: 4, employee_id: 1, pay_period_id: 4},
  {date: '2021-10-27', hours: 1, employee_id: 2, pay_period_id: 4},
  {date: '2021-11-08', hours: 1.5, employee_id: 3, pay_period_id: 5},
]

seed_data = [
  { model: Employee, data: employees },
  { model: PayPeriod, data: pay_periods },
  { model: DateHour, data: date_hours }
]

def seed(seed_data)
  puts "\nSeeding Hours Database"

  seed_data.each do |set|
    puts "\n#{set[:model].name}s"
    set[:data].each do |dt_hash|
      puts dt_hash
      set[:model].create(dt_hash)
    end
  end

  puts "\nSuccessfully seeded Hours Database\n"
end

seed(seed_data)