# Rails Hours

## What is Rails Hours? 
This project is a translation of a Sinatra application server to a Rails application server. The purpose of the project is to provide an API that responds to HTTP requests from a pluggable front end with JSON data for employees and the hours they work in a given pay period. 

## Hours API Endpoints

All endpoints return JSON objects that can be used flexibly by `Hours` consumers.

1. `GET "/employees"`: Returns all employees that exist in the connected database
2. `GET "/employees/:employee_id"`: Returns the `full_name` of the employee with the specified `:employee_id`
3. `GET "/employees/:employee_id/pay_periods/:pp_id/date_hours"`: Returns all hours and dates worked that fall within the pay period specified by `:pp_id`.

### Not yet implemented
4. `POST "/employees/:empoyee_id/pay_periods/:pp_id/date_hours"`: Creates new `date_hours` for the specified employee that fall within the specified pay period. This route returns a `201` status code and an array of successfully created `date_hours`.

## Drafting
### Routes
```ruby
resources :employees do
  resources :pay_periods do 
    resources :date_hours
  end
end


'employees#index'
'employees#show'
'employees#new'
'employees#edit'
'employees#create'
'employees#update'
'employees#destroy'
```

### Controllers
```ruby
class EmployeesController < ActionController
  index
  show
  new
  edit
  create
  update
  destroy
end

class PayPeriodsController < ActionController
  index
  show
  new
  edit
  create
  update
  destroy
end

class DateHoursController < ActionController
  index
  show
  new
  edit
  create
  update
  destroy
end
```

### Views
Should this Rails app be concerned with any views? No, just render json data in the browser

### Models
```ruby
class Employee < ApplicationRecord
  has_many :pay_periods
  has_many :date_hours
end

class PayPeriod < ApplicationRecord
  has_many :date_hours
  has_many :employees
end

class DateHour < ApplicationRecord
  belongs_to :pay_period
  belongs_to :employee
end
```

## Notes
1. I originally included `through: :pay_periods` in the `has_many :date_hours` invocation in the `Employee` model, but in the Rails console, when I tried to chain `date_hours` to `Employee.find(1)`, an `ActiveRecord::StatementInvalid (SQLite3::SQLException: no such column: pay_periods.employee_id)` was raised. 
2. I noticed in the Rails console when I tried to run `PayPeriod.all` that most of the pay_periods were being returned with `nil` `start_dates` and `end_dates`. I originally seeded with a 2d array with inner arrays. I decided to switch to an array of objects, but still had the same `nil` issue. I looked more closely at the `start_date` for the `PayPeriod` with an id of 1, and saw that the month and day had been switched. So I switched the format of the seed data to match. *Look more into date parsing from strings with Rails
3. To fully resolve the `nil` issue with `PayPeriod`s, I had to run `bundle exec rails db:reset`, not just `db:seed`. 
4. All the helper methods for merging an array of "dummy" date_hours that have 0 hours for the `GET /employees/:employee_id/pay_periods/:pay_period_id/date_hours` route so that that route returns all date_hours for the pay_period, not only the date_hours where the employee has worked, were taken and adapted from the Sinatra `Hours` API. I think these could be refactored using Rails `ActiveRecord::Base` methods like `#build`. 