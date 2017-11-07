class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable, :trackable
  devise :database_authenticatable, :registerable, :validatable
  # devise :omniauthable, omniauth_providers: [:github]

  has_one :profile, dependent: :destroy
  has_many :chat_rooms, dependent: :destroy
end
