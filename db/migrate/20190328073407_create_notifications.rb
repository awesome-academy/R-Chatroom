class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :message, foreign_key: true
      t.boolean :read_status

      t.timestamps
    end
  end
end
