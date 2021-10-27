class DateHour < ApplicationRecord
  belongs_to :employee
  has_many :pay_periods
end
