class Room < ApplicationRecord
  VALID_ROOM_NAME_REGEX = /\A[A-Za-z0-9\-_.]+\z/

  has_many :messages, dependent: :delete_all
  has_many :room_members, dependent: :delete_all
  has_many :admin_members, ->{where admin: true}, class_name: :RoomMember
  has_many :users, through: :room_members
  has_many :admins, through: :admin_members, class_name: :User, source: :user

  attr_accessor :user_created_id

  validates :room_name, presence: true,
    length: {minimum: Settings.min_room_name_length,
      maximum: Settings.max_room_name_length},
    format: {with: VALID_ROOM_NAME_REGEX},
    uniqueness: {case_sensitive: false}
  validates :show_name, presence: true,
    length: {minimum: Settings.min_show_name_length,
      maximum: Settings.max_show_name_length}
  validates :description, presence: true,
    length: {minimum: Settings.min_description_length},
    allow_blank: true

  before_save :downcase_room_name
  after_create :set_admin
  before_destroy :disconnect_all_users

  scope :order_by_name, ->{order show_name: :asc}
  scope :find_by_name, ->(search_string){
    where "show_name LIKE :keyword OR room_name LIKE :keyword",
      keyword: "%#{search_string}%"
  }

  def has_joined? user
    users.include? user
  end

  def is_admin? user
    admins.include? user
  end

  def kick user
    sub = ActionCable.server.remote_connections.where current_user: user, room: self
    sub.disconnect if sub
    users.delete user
  end

  def disconnect_all_users
    users.each do |u|
      sub = ActionCable.server.remote_connections.where current_user: u, room: self
      sub.disconnect if sub
    end
  end

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
