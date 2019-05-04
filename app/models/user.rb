class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USER_NAME_REGEX = /\A[A-Za-z0-9\-_.]+\z/

  has_many :messages, dependent: :destroy
  has_many :user_relationships, foreign_key: :relating_id, dependent: :destroy
  has_many :relateds, through: :user_relationships
  has_many :tags, foreign_key: :tagged_id, dependent: :destroy
  has_many :room_members
  has_many :rooms, through: :room_members

  attr_accessor :auth_token, :activation_token

  validates :email, presence: true,
    length: {maximum: Settings.max_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.min_password_length}
  validates :user_name, presence: true, length: {maximum: Settings.max_user_name_length},
    format: {with: VALID_USER_NAME_REGEX},
    uniqueness: {case_sensitive: false}
  validates :show_name, presence: true, length: {maximum: Settings.max_show_name_length}

  before_save :downcase_email
  before_save :downcase_user_name

  before_create :create_activation_digest

  scope :order_by_name, ->{order show_name: :asc}
  scope :find_by_name, ->(search_string){
    where "show_name LIKE :keyword OR user_name LIKE :keyword",
      keyword: "%#{search_string}%"
  }

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.generate_token
    SecureRandom.urlsafe_base64
  end

  def reroll_token
    self.auth_token = User.generate_token
    update_attribute :token_digest, User.digest(auth_token)
  end

  def valid_token? header_token
    BCrypt::Password.new(token_digest) == header_token
  end

  def valid_activation_token? activation_token
    BCrypt::Password.new(activation_digest) == activation_token
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def join_room room
    return if rooms.include? room
    rooms << room
  end

  def leave_room room
    return unless rooms.include? room
    rooms.delete room
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  has_secure_password

  private
  def downcase_email
    self.email = email.downcase
  end

  def downcase_user_name
    self.user_name = user_name.downcase
  end

  def create_activation_digest
    self.activation_token  = User.generate_token
    self.activation_digest = User.digest activation_token
  end
end
