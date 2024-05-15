class CreateHabitHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :habit_histories do |t|
      t.integer :habit_id
      t.integer :user_id
      t.date :date
      t.boolean :completed

      t.timestamps
    end
  end
end
