class AddIsTimedToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :is_timed, :boolean
  end
end
