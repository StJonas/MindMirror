class EmotionLog < ApplicationRecord
  has_many :emotion_log_entries, dependent: :destroy
  belongs_to :user
end
