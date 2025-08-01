class User < ApplicationRecord
  has_many :habits
  has_many :habit_histories, through: :habits
  has_many :prompts
  has_many :journal_entries
  has_many :gratitude_prompts
  has_many :gratitude_entries
  has_many :recharge_logs
  has_many :emotion_logs
  has_many :freetext_entries
  has_many :user_topic_preferences, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  has_secure_password
end