class Episode < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :series

  alias_attribute :title, :name
  validates :name, presence: true
  validates :session_date, inclusion: { in: -> { Date.current.. }, message: "must be today or in the future" }, allow_nil: true, on: :create
end
