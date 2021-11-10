#require 'rails_helper'

RSpec.describe Employee, type: :model do

  # subject { Employee.new(full_name: 'Austin Miller') }
  before(:example) { @employee = build(:employee) }

  it 'should have a full name' do
    expect(@employee.full_name).to eq 'Austin Miller'
  end

  it 'should have id, created_at, and updated_at attributes when saved in the database' do
    employee = create(:employee)
    expect(employee.id).to be_truthy
    expect(employee.created_at).to be_truthy
    expect(employee.updated_at).to be_truthy
  end

  it 'validates presence of full_name on Employee instances' do
    @employee.full_name = nil
    expect(@employee.validate).to be false
    expect(@employee.errors[:full_name]).to include("can't be blank")
    expect(@employee).to_not be_valid
  end

  it 'has an association with date_hours' do
    expect(@employee.date_hours.class.to_s).to eq('DateHour::ActiveRecord_Associations_CollectionProxy')
  end

  it 'has an association with pay_periods' do
    employee = create(:employee, :with_date_hours)
    pp = PayPeriod.find(employee.date_hours.first.pay_period_id)
    expect(pp.start_date).to eq(Date.strptime("2021-09-01"))
  end
end