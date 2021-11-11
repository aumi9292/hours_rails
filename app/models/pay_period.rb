class PayPeriod < ApplicationRecord
  has_many :date_hours

  validates :start_date, :end_date, presence: true
end
