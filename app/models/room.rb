class Room < ApplicationRecord
  has_many :messages
  has_many :room_members
  has_many :users, through: :room_members
end
