FactoryBot.define do
  factory :pay_period do
    start_date { '2021-09-01' }
    end_date { Date.strptime(start_date) + 13.days }
    sequence(:id)
  end
end