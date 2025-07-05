class GratitudeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :gratitude_prompt

  has_many :gratitude_entry_tags
  has_many :tags, through: :gratitude_entry_tags

  validates :content, presence: true
  validates :entry_date, presence: true
end
