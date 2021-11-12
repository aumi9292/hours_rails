describe DateHour, type: :model do
  let(:employee_who_has_worked) { build(:employee, :with_date_hours) }
  let(:valid_date_hour) { build(:date_hour) }

  subject { valid_date_hour }

  it 'should have a valid factory' do
    expect(valid_date_hour.valid?).to eq true
  end

  describe 'validations' do
    it { should validate_presence_of :day }
    it { should validate_presence_of :date }
    it { should validate_numericality_of(:hours).is_less_than_or_equal_to(9.9999) }

    it { should validate_uniqueness_of(:date).scoped_to(:employee_id) }
  end

  describe 'custom validations' do
    it 'should be in the specified pay_period' do
      invalid_date_hour = build(:date_hour, date: 100.days.ago )
      expect(invalid_date_hour.valid?).to be false
    end
  end

  describe 'associations' do
    it { should belong_to :employee }
  end
end

  # it 'should work with traits' do
  #   p @employee_who_has_worked.date_hours
  # end

  # it 'should validate that hours are less than or equal to 9.9999' do
  #   expect { create(:employee, :with_too_many_hours) }.to raise_error(ActiveRecord::RecordInvalid)
  # end

  # it 'should validate that hours are greater than 0' do
  #   expect { create(:employee, :with_too_few_hours) }.to raise_error(ActiveRecord::RecordInvalid)
  # end

  # it 'should validate that each date is unique per employee' do
  #   expect { create(:employee, :with_duplicate_date) }.to raise_error(ActiveRecord::RecordInvalid)
  # end

  # it 'should validate that each date falls within the specified pay_period' do
  #   expect { create(:employee, :with_date_outside_of_pp) }.to raise_error(ActiveRecord::RecordInvalid)
  # end