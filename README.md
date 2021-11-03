# Rails Hours

## What is Rails Hours?
This project is a translation of a Sinatra application server to a Rails application server. The purpose of the project is to provide an API that responds to HTTP requests from a pluggable front end with JSON data for employees and the hours they work in a given pay period.

## Hours API Endpoints

All endpoints return JSON objects that can be used flexibly by `Hours` consumers.

1. `GET "/employees"`: Returns all employees that exist in the connected database
2. `GET "/employees/:employee_id"`: Returns the `full_name` of the employee with the specified `:employee_id`
3. `GET "/employees/:employee_id/pay_periods/:pp_id/date_hours"`: Returns all hours and dates worked that fall within the pay period specified by `:pp_id`.
4. `POST "/date_hours"`: Creates new `date_hours` for the employee and pay period specified in the request body. This route returns a `201` status code and an array of successfully created `date_hours`. This route expects a JSON object like below:

```JSON
{
    "date_hours": [
        {
            "date": "2021-10-17",
            "day": "Sunday",
            "hours": "60",
            "employee_id": "2",
            "pay_period_id":"4"
        }
    ]
}
```

## Drafting
### Routes
```ruby
resources :employees do
  resources :pay_periods do
    resources :date_hours
  end
end
```

### Controllers
```ruby
class EmployeesController < ActionController
  index
  show
  # new
  # edit
  # create
  # update
  # destroy
end

class PayPeriodsController < ActionController
  # index
  # show
  # new
  # edit
  # create
  # update
  # destroy
end

class DateHoursController < ActionController
  index
  show
  # new
  # edit
  create
  # update
  # destroy
end
```

### Views
API, front end is considered pluggable

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
3. To fully resolve the `nil` issue with `PayPeriod`s, I had to run `bundle exec rails db:reset`, not just `db:seed`. Additionally, I found that to make a schema update, it's necessary to run `bundle exec rails db:migrate:reset` and then `bundle exec rails db:seed`. `db:reset` does not re-run the `db/migration` files if you make changes there.
4. All the helper methods for merging an array of "dummy" date_hours that have 0 hours for the `GET /employees/:employee_id/pay_periods/:pay_period_id/date_hours` route so that that route returns all date_hours for the pay_period, not only the date_hours where the employee has worked, were taken and adapted from the Sinatra `Hours` API to start with. They were refactored to use `DateHour.new` to instantiate (but not save to the database) `DateHour`s for `DateHours` where an employee has not worked. Three helper methods were still required to generate all the `DateHour`s for a given pay_period.
5. I noticed that in the `POST /employees/:employee_id/pay_periods/:pay_period_id/date_hours`, I had access to `:employee_id` and `:pay_period_id` from the body of the `POST` request, so instead of nesting access, I moved the route to the top level, `POST /date_hours`.
6. The two validations that are currently implemented are both for the `DateHour` model (which makes sense, because there only exist routes to update `DateHour`s). First, there is a check that the max number of hours is <= 9.9999. Second, there is a check to make sure that for a `POST` to `/date_hours`, the `date` specified in the request body is unique for that employee. I ran into a lot of issues with validations. I ended up using an `ActiveRecord::Base::Transaction`, along with the `create!` method and a `begin..rescue` block. The way the API works, a POST request can specify multiple date_hours that need to be created and saved in the database. The transaction ensures that if any are invalid, none will be saved to the database. Two tricky parts of this were figuring out that `create` can take an array of objects, and that `create!` would actually trigger a rollback, while `create` would not. I also implemented a custom validation method for the `DateHour` model that checks whether there already exists a `DateHour` record with the specified date, and adds an error to the `errors` array if so. One tricky part here was reading into the differences beteen `ActiveRecord::Validations::validate` (for custom validations, expects a method identifier for a method you implement) and `ActiveRecord::Validations::validates` (for built in validations or custom validation classes, expects the identifier for a rails validator or custom validation class).
7. When I first tried to make a post request, an `ActionController::InvalidAuthenticityToken` error was raised. I added this line to `DateHoursController`:
`skip_before_action :verify_authenticity_token`. This seemed hacky, so I came back to it later and found that you can specify that the base application controller could also inherit from `ActionController::API` to prevent this error from being raised.

## Error Handling
1. If a user tries to create a new `date_hour` record and the number of hours is greater than 9.9999, the `date_hour` will not be created and a JSON object with an explanatory error will be returned as the body of the response.
2. If a user tries to create a new `date_hour` record and contains a date that the specified user has already worked, the `date_hour` will not be created and will receive a JSON object with an explanatory error as the body of the response.