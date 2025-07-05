class JournalEntry < ApplicationRecord
  belongs_to :user
  belongs_to :prompt

  validates :content, presence: true
  validates :entry_date, presence: true
  validates :prompt_title, presence: true

  has_many :journal_entry_tags
  has_many :tags, through: :journal_entry_tags
end