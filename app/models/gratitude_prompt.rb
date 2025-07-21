class GratitudePrompt < ApplicationRecord
  belongs_to :user, optional: true

  validates :weekly, inclusion: { in: [true, false] }
  validates :predefined, inclusion: { in: [true, false] }
  validates :title, presence: true, uniqueness: { scope: :user_id }
end
