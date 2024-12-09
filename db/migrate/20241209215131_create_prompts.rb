class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts do |t|
      t.string :title, null: false
      t.boolean :weekly, null: false
      t.references :user, foreign_key: true, null: true
      t.boolean :predefined, default: false, null: false

      t.timestamps
    end
  end
end
