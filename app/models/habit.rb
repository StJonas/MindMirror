class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_histories, dependent: :destroy

  validates :name, presence: true
end