class Episode < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :series

  alias_attribute :title, :name
  validates :name, presence: true
end
