class CreateJournalEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :journal_entries do |t|
      t.text :content, null: false
      t.date :entry_date, null: false
      t.references :user, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true

      t.timestamps
    end
  end
end
