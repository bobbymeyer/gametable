require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  test "valid with title and series" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "Session One")
    assert episode.valid?
  end

  test "invalid without name" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "")
    assert_not episode.valid?
    assert_includes episode.errors[:name], "can't be blank"
  end

  test "invalid without series" do
    episode = Episode.new(title: "Session One")
    assert_not episode.valid?
    assert_includes episode.errors[:series], "must exist"
  end

  test "belongs to series" do
    series = Series.create!(name: "Test Series")
    episode = series.episodes.create!(title: "Episode 1")
    assert_equal series, episode.series
  end

  test "invalid when session_date is in the past on create" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "Session One", session_date: 1.day.ago)
    assert_not episode.valid?
    assert_includes episode.errors[:session_date], "must be today or in the future"
  end

  test "valid when session_date is today or in future on create" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "Session One", session_date: Date.current)
    assert episode.valid?
  end

  test "session_date may be nil on create" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "Session One", session_date: nil)
    assert episode.valid?
  end
end
