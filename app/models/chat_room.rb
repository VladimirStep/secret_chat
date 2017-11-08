class ChatRoom < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :messages, dependent: :destroy
  has_many :chat_accesses, dependent: :destroy
  has_many :visitors, class_name: 'User', through: :chat_accesses

  has_secure_password

  validates :name, presence: true, length: { in: 2..50 }
  validates :owner, presence: true

  def has_granted_access?(current_user)
    owner == current_user || chat_accesses.find_by(user: current_user)&.opened?
  end
end
