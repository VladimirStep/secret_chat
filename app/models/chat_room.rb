class ChatRoom < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id

  has_secure_password

  validates :name, presence: true, length: { in: 2..50 }
end
