class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_histories

  validates :name, presence: true
end