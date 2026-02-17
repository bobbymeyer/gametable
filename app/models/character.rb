class Character < ApplicationRecord
  belongs_to :series

  validates :name, presence: true
end
