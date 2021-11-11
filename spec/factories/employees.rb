FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }

    trait :with_date_hours do
      after(:create) do |employee|
        pay_period = create(:pay_period)
        create(
          :date_hour,
          employee_id: employee.id,
          pay_period_id: pay_period.id
          )
      end
    end

    trait :with_too_many_hours do
      after(:create) do |employee|
        pay_period = create(:pay_period)
        create(
          :date_hour,
          hours: 10,
          employee_id: employee.id,
          pay_period_id: pay_period.id
          )
      end
    end

    trait :with_too_few_hours do
      after(:create) do |employee|
        pay_period = create(:pay_period)
        create(
          :date_hour,
          hours: 0,
          employee_id: employee.id,
          pay_period_id: pay_period.id
          )
      end
    end

    trait :with_duplicate_date do
      after(:create) do |employee|
        pay_period = create(:pay_period)
        create(
          :date_hour,
          employee_id: employee.id,
          pay_period_id: pay_period.id
          )

          create(
            :date_hour,
            employee_id: employee.id,
            pay_period_id: pay_period.id
            )
      end
    end

    trait :with_date_outside_of_pay_period do
      after(:create) do |employee|
        pay_period = create(:pay_period)
        create(
          :date_hour,
          date: '2021-09-15',
          employee_id: employee.id,
          pay_period_id: pay_period.id
          )
      end
    end

  end
end
