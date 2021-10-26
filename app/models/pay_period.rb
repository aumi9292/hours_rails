class PayPeriod < ApplicationRecord
  has_many :date_hours
  has_many :employees
end
