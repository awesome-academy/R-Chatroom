class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USER_NAME_REGEX = /\A[a-z0-9]+\z/

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

  has_secure_password

  private
    def downcase_email
      self.email = email.downcase
    end

    def downcase_user_name
      self.user_name = user_name.downcase
    end
end
