class HabitHistory < ApplicationRecord
  belongs_to :habit
  belongs_to :user

  validates :habit_id, presence: true
  validates :user_id, presence: true
  validates :date, presence: true
end