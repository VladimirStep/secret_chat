FactoryBot.define do
  factory :message do
    author
    chat_room
    body { Faker::Lorem.sentence }
  end
end
