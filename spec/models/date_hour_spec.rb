#require 'rails_helper'

describe DateHour, type: :model do
  # employee = Employee.new(full_name: 'Austin Miller')
  # pay_period = PayPeriod.new(start_date: '2021-09-01', end_date: '2021-09-14')
  # subject { DateHour.new(date: '2021-09-01', hours: 4, employee_id: 1, pay_period_id: 1) }
  # before { subject.save }

  before(:each) { @employee_who_has_worked = create(:employee, :with_date_hours) }

  # it 'should work with traits' do
  #   p @employee_who_has_worked.date_hours
  # end


  it 'should validate that hours are less than or equal to 9.9999' do
    expect { create(:employee, :with_too_many_hours) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should validate that hours are greater than 0' do
    expect { create(:employee, :with_too_few_hours) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should validate that each date is unique per employee' do
    expect { create(:employee, :with_duplicate_date) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should validate that each date falls within the specified pay_period' do
    expect { create(:employee, :with_date_outside_of_pp) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end