class SeriesProducer < ApplicationRecord
  belongs_to :series
  belongs_to :user

  validates :user_id, uniqueness: { scope: :series_id }
  validate :user_not_executive_producer

  private

  def user_not_executive_producer
    return unless series && user
    return unless series.created_by_id == user_id

    errors.add(:user_id, "is already the Executive Producer")
  end
end
