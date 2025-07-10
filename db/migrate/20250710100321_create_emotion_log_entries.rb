class CreateEmotionLogEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :emotion_log_entries do |t|
      t.references :emotion_log, null: false, foreign_key: true
      t.references :emotion, null: false, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
