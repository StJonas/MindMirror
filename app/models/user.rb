class User < ApplicationRecord
  has_many :habits
  has_many :habit_histories, through: :habits
  has_many :prompts
  has_many :journal_entries
  has_many :gratitude_prompts
  has_many :gratitude_entries

  validates :username, presence: true, uniqueness: true
  has_secure_password
end