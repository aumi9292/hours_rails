describe Employee, type: :model do
  it 'should have a valid factory' do
    expect(build(:employee).valid?).to eq true
  end

  it { should validate_presence_of :full_name }
  it { should have_many :date_hours }
end



  # it 'should have a full name' do
  #   expect(employee.full_name).to eq 'Austin Miller'
  # end

  # it 'validates presence of full_name' do
  #   employee = build(:employee, full_name: nil)
  #   expect(employee.valid?).to eq false
  #   expect(employee.errors.messages[:full_name]).to include("can't be blank")
  # end

  # it 'has an association with date_hours' do
  #   dhs = DateHour.find(employee.date_hour_ids)
  #   expect(employee.date_hours).to eq(dhs)
  # end

  # it 'has an association with pay_periods' do
  #   employee = create(:employee, :with_date_hours)
  #   pay_period = PayPeriod.find(employee.date_hours.first.pay_period_id)
  #   expect(pay_period.start_date).to eq(Date.strptime("2021-09-01"))
  # end
