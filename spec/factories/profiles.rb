FactoryBot.define do
  factory :profile do
    user
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    gender { %w(male female).sample }
  end
end
