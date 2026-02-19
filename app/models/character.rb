class Character < ApplicationRecord
  belongs_to :series

  has_one_attached :portrait

  attribute :xp, :integer, default: 0

  validates :name, presence: true
end
