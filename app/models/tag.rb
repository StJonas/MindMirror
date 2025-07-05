class Tag < ApplicationRecord
  has_many :gratitude_entry_tags
  has_many :gratitude_entries, through: :gratitude_entry_tags

  has_many :journal_entry_tags
  has_many :journal_entries, through: :journal_entry_tags
end