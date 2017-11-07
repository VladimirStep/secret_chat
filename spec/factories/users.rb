FactoryBot.define do
  factory :user, aliases: [:owner, :author] do
    email { Faker::Internet.unique.email }
    password 'password'
  end
end
