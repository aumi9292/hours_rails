require 'rails_helper'

describe DateHour, type: :model do
  employee = Employee.new(full_name: 'Austin Miller')
  pay_period = PayPeriod.new(start_date: '2021-09-01', end_date: '2021-09-14')
  subject { DateHour.new(date: '2021-09-01', hours: 4, employee_id: 1, pay_period_id: 1) }
  before { subject.save }

  p employee.date_hours


  # it 'should validate that hours are less than or equal to 9.9999' do
  # end

  # it 'should validate that hours are greater than 0' do
  # end

  # it 'should validate that each date is unique per employee' do
  # end

  # it 'should validate that each date falls within the specified pay_period' do
  # end
end