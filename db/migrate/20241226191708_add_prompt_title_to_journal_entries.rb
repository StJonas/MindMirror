class AddPromptTitleToJournalEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :journal_entries, :prompt_title, :string
  end
end
