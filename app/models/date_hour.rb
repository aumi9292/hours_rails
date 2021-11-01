class DateHour < ApplicationRecord

  validates :hours, numericality: { less_than_or_equal_to: 9.9999, message: "Hours must be less than or equal to 9.9999" }
  validate :dates_must_be_unique_per_employee

  belongs_to :employee
  has_many :pay_periods

  def dates_must_be_unique_per_employee
    p "in validator: #{employee.date_hours.find_by(date: self.date)}"
    if employee.date_hours.find_by(date: self.date).present?
      errors.add(:unique_date, "dates must be unique")
    end
  end

  
end
