class AddDurationToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :duration, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
