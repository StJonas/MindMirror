class User < ApplicationRecord
  has_many :habits
  has_many :habit_histories, through: :habits

  validates :username, presence: true, uniqueness: true
  has_secure_password
end