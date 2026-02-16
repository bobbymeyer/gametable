require "test_helper"

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
    @series = Series.create!(name: "Test Series")
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
  end

  test "get new" do
    get new_series_episode_path(@series)
    assert_response :success
  end

  test "create episode" do
    assert_difference "Episode.count", 1 do
      post series_episodes_path(@series), params: { episode: { title: "Session One", notes: "First session." } }
    end
    episode = Episode.last
    assert_redirected_to episode_path(episode)
    assert_equal "Session One", episode.title
    assert_equal @series, episode.series
  end

  test "get show" do
    episode = @series.episodes.create!(title: "Episode 1")
    get episode_path(episode)
    assert_response :success
  end

  test "get edit" do
    episode = @series.episodes.create!(title: "Episode 1")
    get edit_episode_path(episode)
    assert_response :success
  end

  test "update episode" do
    episode = @series.episodes.create!(title: "Old Title")
    patch episode_path(episode), params: { episode: { title: "New Title" } }
    assert_redirected_to episode_path(episode)
    episode.reload
    assert_equal "New Title", episode.title
  end

  test "destroy episode" do
    episode = @series.episodes.create!(title: "To Delete")
    assert_difference "Episode.count", -1 do
      delete episode_path(episode)
    end
    assert_redirected_to series_path(@series)
  end

  test "create with invalid params re-renders new" do
    post series_episodes_path(@series), params: { episode: { title: "", notes: "No title." } }
    assert_response :unprocessable_entity
  end
end
