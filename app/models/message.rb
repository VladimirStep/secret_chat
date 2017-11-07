class Message < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :chat_room

  validates :body, :author, :chat_room, presence: true
end
