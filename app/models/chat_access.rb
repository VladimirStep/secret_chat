class ChatAccess < ApplicationRecord
  enum status: [:opened, :closed]

  belongs_to :user
  belongs_to :chat_room
end
