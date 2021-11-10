class DateHour < ApplicationRecord

  validates :hours, :numericality => { less_than_or_equal_to: 9.9999, message: "Hours worked for all dates must be less than 10" }
  validates :hours, :numericality => { greater_than: 0, message: "Hours worked for all dates must be greater than 0" }
  validate :unique_dates_validator, on: :create
  validate :date_in_pp_validator

  belongs_to :employee
  has_many :pay_periods

  private

  def unique_dates_validator
    employee = Employee.find(employee_id)
    d_h_exists = !!employee.date_hours.find_by(date: self.date)
    errors.add(:date, "All date/s must only be entered once") if d_h_exists
  end

  def date_in_pp_validator
    pay_period = PayPeriod.find(self.pay_period_id)
    date_in_pay_period = self.date.between? pay_period.start_date, pay_period.end_date
    errors.add(:date, "All dates must be within pay_period #{pay_period_id}") unless date_in_pay_period
  end

end
