class AddStatsVisibilityToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stats_visibility, :json
  end
end
