class MakePromptIdNullableInJournalEntries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :journal_entries, :prompt_id, true
  end
end
