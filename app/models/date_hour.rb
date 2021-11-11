class DateHour < ApplicationRecord

  validates :day, presence: true
  validates :date, presence: true, uniqueness: { scope: :employee_id }
  validates :hours, numericality: { less_than_or_equal_to: 9.9999 }
  validates :hours, numericality: { greater_than: 0 }
  validate :date_in_pp_validator

  belongs_to :employee
  belongs_to :pay_period

  private

  def date_in_pp_validator
    return unless date

    pay_period = PayPeriod.find(pay_period_id)
    date_in_pay_period = date.between? pay_period.start_date, pay_period.end_date
    errors.add(:date, "must be within pay period") unless date_in_pay_period
  end
end
