require "test_helper"

class SeriesTest < ActiveSupport::TestCase
  test "valid with name" do
    series = Series.new(name: "Polychrome")
    assert series.valid?
  end

  test "invalid without name" do
    series = Series.new(description: "A campaign")
    assert_not series.valid?
    assert_includes series.errors[:name], "can't be blank"
  end

  test "has many episodes" do
    series = Series.create!(name: "Test Series")
    series.episodes.create!(title: "Episode 1")
    series.episodes.create!(title: "Episode 2")
    assert_equal 2, series.episodes.count
  end

  test "destroying series destroys episodes" do
    series = Series.create!(name: "Test Series")
    series.episodes.create!(title: "Episode 1")
    assert_difference "Episode.count", -1 do
      series.destroy
    end
  end

  test "producer? is true for created_by" do
    user = User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12")
    series = Series.create!(name: "Test", created_by: user)
    assert series.producer?(user)
  end

  test "producer? is true for added producer" do
    ep = User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12")
    producer = User.create!(email: "producer@example.com", password: "secret12", password_confirmation: "secret12")
    series = Series.create!(name: "Test", created_by: ep)
    series.series_producers.create!(user: producer)
    assert series.producer?(producer)
  end

  test "producer? is false for unrelated user" do
    ep = User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12")
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    series = Series.create!(name: "Test", created_by: ep)
    assert_not series.producer?(other)
  end
end
