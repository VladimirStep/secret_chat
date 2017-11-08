class ChatAccess < ApplicationRecord
  enum status: [:opened, :closed]

  belongs_to :user
  belongs_to :chat_room

  validates :user, :chat_room, :status, presence: true
end
