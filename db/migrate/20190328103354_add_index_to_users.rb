class AddIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :token_digest, unique: true
  end
end
