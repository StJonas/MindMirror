class ChangeUserIdNullOnGratitudePrompts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :gratitude_prompts, :user_id, true
  end
end
