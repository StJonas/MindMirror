class EmotionLogEntry < ApplicationRecord
  belongs_to :emotion_log
  belongs_to :emotion
end
