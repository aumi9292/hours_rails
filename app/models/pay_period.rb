class PayPeriod < ApplicationRecord
  has_many :date_hours
  has_many :employees

  validates :start_date, :end_date, presence: true
end
