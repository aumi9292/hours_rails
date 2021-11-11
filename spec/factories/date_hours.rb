FactoryBot.define do
  factory :date_hour do
    date { '2021-09-01' }
    day { 'Wednesday' }
    hours { 8 }
    employee { create(:employee) }
    pay_period  { create(:pay_period) }
  end
end

# write an after_create hook to make sure that the date is within the correct pay period