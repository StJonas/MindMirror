class Prompt < ApplicationRecord
  belongs_to :user, optional: true
  has_many :journal_entries

  validates :title, presence: true
  validates :weekly, inclusion: { in: [true, false] }
  validates :predefined, inclusion: { in: [true, false] }
end