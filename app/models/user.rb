class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  before_create :set_first_user_as_admin

  def self.authenticate_by(email:, password:)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end

  private

  def set_first_user_as_admin
    self.admin = true if User.count.zero?
  end
end
