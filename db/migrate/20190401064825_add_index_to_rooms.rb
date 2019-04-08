class AddIndexToRooms < ActiveRecord::Migration[5.2]
  def change
    add_index :rooms, :room_name, unique: true
  end
end
