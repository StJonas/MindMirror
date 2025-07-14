class CreateRechargeLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :recharge_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.string :exercise
      t.boolean :completed
      t.text :note

      t.timestamps
    end
  end
end
