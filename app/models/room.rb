class Room < ApplicationRecord
  VALID_ROOM_NAME_REGEX = /\A[a-z0-9-_.]+\z/

  has_many :messages
  has_many :room_members
  has_many :users, through: :room_members

  attr_accessor :user_created_id

  validates :room_name, presence: true, length: {maximum: Settings.max_room_name_length},
    format: {with: VALID_ROOM_NAME_REGEX},
    uniqueness: {case_sensitive: false}
  validates :show_name, presence: true, length: {maximum: Settings.max_show_name_length}

  before_save :downcase_room_name
  after_save :set_admin

  scope :order_by_name, ->{order show_name: :asc}

  private
    def downcase_room_name
      self.room_name = room_name.downcase
    end

    def set_admin
      user_created = User.find_by id: user_created_id
      user_created.join_room self
      room_members.find_by(user_id: user_created.id).update admin: true
    end
end
