require "test_helper"

class SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
  end

  test "get index" do
    get series_index_path
    assert_response :success
  end

  test "get new" do
    get new_series_path
    assert_response :success
  end

  test "create series" do
    assert_difference "Series.count", 1 do
      post series_index_path, params: { series: { name: "Polychrome", description: "A campaign." } }
    end
    assert_redirected_to Series.last
    assert_equal "Polychrome", Series.last.name
  end

  test "get show" do
    series = Series.create!(name: "Test Series")
    get series_path(series)
    assert_response :success
  end

  test "get edit" do
    series = Series.create!(name: "Test Series")
    get edit_series_path(series)
    assert_response :success
  end

  test "update series" do
    series = Series.create!(name: "Old Name")
    patch series_path(series), params: { series: { name: "New Name", description: "Updated." } }
    assert_redirected_to series
    series.reload
    assert_equal "New Name", series.name
  end

  test "destroy series" do
    series = Series.create!(name: "To Delete")
    assert_difference "Series.count", -1 do
      delete series_path(series)
    end
    assert_redirected_to series_index_path
  end

  test "create with invalid params re-renders new" do
    post series_index_path, params: { series: { name: "", description: "No name." } }
    assert_response :unprocessable_entity
  end

  test "unauthenticated cannot access index" do
    delete logout_path
    get series_index_path
    assert_redirected_to login_path
  end
end
