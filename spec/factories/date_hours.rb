FactoryBot.define do
  factory :date_hour do
    date { Date.today }
    day { date.strftime('%A') }
    hours { 8 }
    employee { create(:employee) }
    pay_period  { create(:pay_period) }
  end

  # after :create do |date_hour|
  #   p date_hour
  #   create :pay_period, start_date: date_hour.date
  # end
end