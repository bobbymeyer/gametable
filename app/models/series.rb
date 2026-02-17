class Series < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :created_by, class_name: "User", optional: true
  has_many :series_producers, dependent: :destroy
  has_many :producers, through: :series_producers, source: :user
  has_many :episodes, dependent: :destroy
  has_many :cast, class_name: "Character", dependent: :destroy

  validates :name, presence: true

  def producer?(user)
    return false if user.blank?
    return true if created_by_id == user.id
    producers.exists?(user.id)
  end

  def executive_producer
    created_by
  end

  def executive_producer?(user)
    created_by_id == user&.id
  end
end
