class MakeGratitudePromptIdNullableInGratitudeEntries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :gratitude_entries, :gratitude_prompt_id, true
  end
end
