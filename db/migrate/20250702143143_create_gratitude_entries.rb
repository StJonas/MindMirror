class CreateGratitudeEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :gratitude_entries do |t|
      t.text :content
      t.date :entry_date
      t.references :user, null: false, foreign_key: true
      t.references :gratitude_prompt, null: false, foreign_key: true
      t.string :prompt_title

      t.timestamps
    end
  end
end
