class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USER_NAME_REGEX = /\A[A-Za-z0-9\-_.]+\z/

  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable, :confirmable, :validatable

  has_many :messages, dependent: :destroy
  has_many :user_relationships, foreign_key: :relating_id, dependent: :destroy
  has_many :relateds, through: :user_relationships
  has_many :tags, foreign_key: :tagged_id, dependent: :destroy
  has_many :room_members
  has_many :rooms, through: :room_members

  validates :user_name, presence: true, length: {maximum: Settings.max_user_name_length},
    format: {with: VALID_USER_NAME_REGEX},
    uniqueness: {case_sensitive: false}
  validates :show_name, presence: true, length: {maximum: Settings.max_show_name_length}

  before_save :downcase_email
  before_save :downcase_user_name

  scope :order_by_name, ->{order show_name: :asc}
  scope :find_by_name, ->(search_string){
    where "show_name LIKE :keyword OR user_name LIKE :keyword",
      keyword: "%#{search_string}%"
  }

  def join_room room
    return if rooms.include? room
    rooms << room
  end

  def leave_room room
    return unless rooms.include? room
    rooms.delete room
  end

  def valid_token? token
    Devise.secure_compare token, authentication_token
  end

  private
  def downcase_email
    email.downcase!
  end

  def downcase_user_name
    user_name.downcase!
  end
end
