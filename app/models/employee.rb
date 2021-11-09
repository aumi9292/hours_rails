class Employee < ApplicationRecord
  has_many :pay_periods
  has_many :date_hours

  validates :full_name, presence: true
end
