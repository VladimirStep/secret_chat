FactoryBot.define do
  factory :chat_room do
    owner
    name Faker::Book.title
    password_digest 'password'
  end
end
