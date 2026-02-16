require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  test "valid with title and series" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "Session One")
    assert episode.valid?
  end

  test "invalid without title" do
    series = Series.create!(name: "Test Series")
    episode = Episode.new(series: series, title: "")
    assert_not episode.valid?
    assert_includes episode.errors[:title], "can't be blank"
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
end
