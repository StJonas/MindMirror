class AddTypeToEmotions < ActiveRecord::Migration[7.1]
  def change
    add_column :emotions, :category, :string
  end
end
