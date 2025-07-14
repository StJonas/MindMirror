class CreateFreetextEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :freetext_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.date :date
      t.boolean :done_offline

      t.timestamps
    end
  end
end
