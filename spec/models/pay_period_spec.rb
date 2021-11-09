require 'rails_helper'

describe PayPeriod, type: :model do

  subject { PayPeriod.new(start_date: '2021-09-01', end_date: '2021-09-14') }
  before { subject.save }

  it 'should have an id' do
    expect(subject).to respond_to(:id)
  end

  it 'should have a start date that is an instance of the Date class' do
    expect(subject).to respond_to(:start_date)
    expect(subject.start_date).to  be_instance_of Date
  end

  it 'should have an end date that is an instance of the Date class' do
    expect(subject).to respond_to(:end_date)
    expect(subject.start_date).to be_instance_of Date
  end

  it 'should validate presence of start date' do
    subject.start_date = nil
    subject.validate
    expect(subject.errors[:start_date]).to include("can't be blank")
  end

  it 'should validate presence of end date' do
    subject.end_date = nil
    subject.validate
    expect(subject.errors[:end_date]).to include("can't be blank")
  end
end