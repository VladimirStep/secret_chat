FactoryBot.define do
  factory :user, aliases: [:owner] do
    email Faker::Internet.unique.email
    password 'password'
  end
end
