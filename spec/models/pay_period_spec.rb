#require 'rails_helper'

describe PayPeriod, type: :model do

  before(:each) { @pp = create(:pay_period) }

  it 'should have an id' do
    expect(@pp.id).to be >= 1
  end

  it 'should have a start_date that is an instance of the Date class' do
    expect(@pp.start_date).to be_instance_of(Date)
    expect(@pp.start_date).to eq(Date.strptime('2021-09-01'))
  end

  it 'should have an end date that is an instance of the Date class' do
    expect(@pp.end_date).to be_instance_of(Date)
    expect(@pp.end_date).to eq(@pp.start_date + 13.days)
  end

  it 'should validate the presence of start_date' do
    expect(@pp.errors[:start_date]).to be_empty
    @pp.start_date = nil
    @pp.validate
    expect(@pp.errors[:start_date]).to include("can't be blank")
  end

  it 'should validate the presence of end_date' do
    expect(@pp.errors[:end_date]).to be_empty
  end
end

# below is my first iteration of the pay_period test suite, which used subject instead of factory bot instances
=begin
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
=end