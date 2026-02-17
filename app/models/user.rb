class User < ApplicationRecord
  has_secure_password

  has_many :created_series, class_name: "Series", foreign_key: :created_by_id, dependent: :nullify
  has_many :series_producers, dependent: :destroy
  has_many :produced_series, through: :series_producers, source: :series

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
