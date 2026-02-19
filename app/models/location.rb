class Location < ApplicationRecord
  belongs_to :series
  has_one_attached :backdrop

  validates :name, presence: true
end
