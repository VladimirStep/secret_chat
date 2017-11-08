FactoryBot.define do
  factory :chat_access do
    user
    chat_room
    status { %w(opened closed).sample }
  end
end
