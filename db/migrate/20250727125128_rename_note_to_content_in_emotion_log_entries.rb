class RenameNoteToContentInEmotionLogEntries < ActiveRecord::Migration[7.1]
  def change
    rename_column :emotion_log_entries, :note, :content
  end
end
