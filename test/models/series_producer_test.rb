require "test_helper"

class SeriesProducerTest < ActiveSupport::TestCase
  test "valid with series and user" do
    series = Series.create!(name: "Test", created_by: User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12"))
    producer = User.create!(email: "p@example.com", password: "secret12", password_confirmation: "secret12")
    sp = series.series_producers.build(user: producer)
    assert sp.valid?
  end

  test "invalid when user is executive producer" do
    ep = User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12")
    series = Series.create!(name: "Test", created_by: ep)
    sp = series.series_producers.build(user: ep)
    assert_not sp.valid?
    assert_includes sp.errors[:user_id], "is already the Executive Producer"
  end

  test "invalid duplicate user for same series" do
    series = Series.create!(name: "Test", created_by: User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12"))
    producer = User.create!(email: "p@example.com", password: "secret12", password_confirmation: "secret12")
    series.series_producers.create!(user: producer)
    duplicate = series.series_producers.build(user: producer)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end
end
