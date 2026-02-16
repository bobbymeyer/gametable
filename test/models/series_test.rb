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
end
