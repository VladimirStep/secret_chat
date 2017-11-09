class ChatRoom < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :messages, dependent: :destroy
  has_many :chat_accesses, dependent: :destroy
  has_many :visitors, class_name: 'User', through: :chat_accesses

  has_secure_password

  validates :name, presence: true, length: { in: 2..50 }
  validates :owner, presence: true

  before_update :reset_accesses

  def has_granted_access?(current_user)
    owner == current_user || chat_accesses.find_by(user: current_user)&.opened?
  end

  private

  def reset_accesses
    return unless password_digest_changed?
    old_instance = ChatRoom.new(changed_attributes)
    chat_accesses.update_all(status: 'closed') unless old_instance.authenticate(password)
  end
end
