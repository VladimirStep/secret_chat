class Profile < ApplicationRecord
  enum gender: [:male, :female]

  belongs_to :user

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :user, :gender, presence: true
end
