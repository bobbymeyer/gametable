require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid with name and series" do
    series = Series.create!(name: "Test Series")
    location = Location.new(series: series, name: "The Tavern")
    assert location.valid?
  end

  test "invalid without name" do
    series = Series.create!(name: "Test Series")
    location = Location.new(series: series, name: "")
    assert_not location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "invalid without series" do
    location = Location.new(name: "The Tavern")
    assert_not location.valid?
    assert_includes location.errors[:series], "must exist"
  end

  test "belongs to series" do
    series = Series.create!(name: "Test Series")
    location = series.locations.create!(name: "The Tavern")
    assert_equal series, location.series
  end

  test "has backdrop attachment" do
    series = Series.create!(name: "Test Series")
    location = series.locations.create!(name: "The Tavern")
    assert_not location.backdrop.attached?
    location.backdrop.attach(
      io: StringIO.new("fake image"),
      filename: "backdrop.jpg",
      content_type: "image/jpeg"
    )
    assert location.backdrop.attached?
  end

  test "destroying series destroys locations" do
    series = Series.create!(name: "Test Series")
    series.locations.create!(name: "The Tavern")
    assert_difference "Location.count", -1 do
      series.destroy
    end
  end
end
