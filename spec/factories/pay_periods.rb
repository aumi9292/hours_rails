FactoryBot.define do
  factory :pay_period do
    start_date { 5.days.ago }
    end_date { start_date + 14.days }
  end
end