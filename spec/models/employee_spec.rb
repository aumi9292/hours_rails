require 'rails_helper'

RSpec.describe Employee, type: :model do

  subject { Employee.new(full_name: 'Austin Miller') }
  before { subject.save }

  it 'should have a full name' do
    expect(subject.full_name).to eq 'Austin Miller'
  end

  it 'should have id, created_at, and updated_at attributes when saved in the database' do
    expect(subject).to respond_to(:id, :created_at, :updated_at)
  end

  it 'validates presence of full_name on Employee instances' do
    subject.full_name = nil
    subject.validate
    expect(subject.errors[:full_name]).to include("can't be blank")

    expect(subject).to_not be_valid
  end
end