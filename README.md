# Rails Hours

## What is Rails Hours? 
This project is a translation of a Sinatra application server to a Rails application server. The purpose of the project is to provide an API that responds to HTTP requests from a pluggable front end with JSON data for employees and the hours they work in a given pay period. 

## Drafting
### Routes
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

### Controllers
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

### Views
Should this Rails app be concerned with any views? No, just render json data in the browser

### Models
class EmployeesController < ActionController
  has_many :pay_periods
  has_many :date_hours, through: :pay_periods
end

class PayPeriodsController < ActionController
  has_many :date_hours
  has_many :employees
end

class DateHoursController < ActionController
  belongs_to :pay_period
  belongs_to :employee
end