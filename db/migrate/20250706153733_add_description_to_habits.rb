class AddDescriptionToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :description, :string
  end
end
