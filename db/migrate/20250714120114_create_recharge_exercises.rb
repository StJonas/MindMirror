class CreateRechargeExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :recharge_exercises do |t|
      t.string :title
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
