describe PayPeriod, type: :model do

  let(:pay_period) { build(:pay_period) }

  describe 'validations' do
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }
  end

  describe 'associations' do
    it { should have_many :date_hours }
  end
end

  # it 'should validate the presence of start_date' do
  #   expect(pay_period.errors[:start_date]).to be_empty

  #   pay_period_without_start_date = build(:pay_period, start_date: nil)
  #   pay_period_without_start_date.validate
  #   expect(pay_period_without_start_date.errors.messages[:start_date]).to include("can't be blank")
  #   expect(pay_period_without_start_date.valid?).to be false
  # end

  # it 'should validate the presence of end_date' do
  #   expect(pay_period.errors[:end_date]).to be_empty
  #   pay_period_without_end_date = build(:pay_period, end_date: nil)
  #   pay_period_without_end_date.validate
  #   expect(pay_period_without_end_date.valid?).to be false
  # end

  # it 'should have an association with date_hours' do
  #   dhs = DateHour.find(pay_period.date_hour_ids)
  #   expect(pay_period.date_hours).to eq dhs
  # end

  # it 'should have an association with employees' do
  #   employees = Employee.find(pay_period.employee_ids)
  #   expect(employees).to eq pay_period.employees
  # end