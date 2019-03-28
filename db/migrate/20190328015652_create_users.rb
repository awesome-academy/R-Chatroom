class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :show_name
      t.string :password_digest
      t.string :token_digest
      t.string :email

      t.timestamps
    end
  end
end
