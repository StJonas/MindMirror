class CreateGratitudePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :gratitude_prompts do |t|
      t.string :title
      t.boolean :predefined
      t.boolean :weekly
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
