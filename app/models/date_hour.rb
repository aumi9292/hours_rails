class DateHour < ApplicationRecord

  validates :hours, :numericality => { less_than_or_equal_to: 9.9999, message: "Hours must be less than or equal to 9.9999" }
  validate :unique_dates_validator

  belongs_to :employee
  has_many :pay_periods

  private

  def unique_dates_validator
    d_h_exists = !!employee.date_hours.find_by(date: self.date)
    errors.add(:unique_date, "dates must be unique") if d_h_exists
  end

  
end
