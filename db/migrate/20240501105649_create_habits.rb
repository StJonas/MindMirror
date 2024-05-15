class CreateHabits < ActiveRecord::Migration[7.1]
  def change
    create_table :habits do |t|
      t.string :name
      t.integer :frequency
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
  end
end
