class CreateRoomMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :room_members do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :admin

      t.timestamps
    end

    add_index :room_members, [:room_id, :user_id], unique: true
  end
end
