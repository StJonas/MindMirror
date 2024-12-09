class JournalEntry < ApplicationRecord
  belongs_to :user
  belongs_to :prompt

  validates :content, presence: true
  validates :entry_date, presence: true
end