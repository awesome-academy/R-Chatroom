class CreateUserRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :user_relationships do |t|
      t.timestamps
      t.references :relating, foreign_key: {to_table: :users}
      t.references :related, foreign_key: {to_table: :users}
    end

    add_index :user_relationships, [:relating_id, :related_id], unique: true
  end
end
