class CreateGratitudeEntryTags < ActiveRecord::Migration[7.1]
  def change
    create_table :gratitude_entry_tags do |t|
      t.references :gratitude_entry, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
