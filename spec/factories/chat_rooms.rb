FactoryBot.define do
  factory :chat_room do
    owner
    name { Faker::Book.unique.title }
    password 'password'
  end
end
