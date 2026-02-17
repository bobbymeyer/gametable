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

  test "create series sets current user as executive producer" do
    assert_difference "Series.count", 1 do
      post series_index_path, params: { series: { name: "Polychrome", description: "A campaign." } }
    end
    assert_redirected_to Series.last
    series = Series.last
    assert_equal "Polychrome", series.name
    assert_equal @user, series.created_by
  end

  test "get show" do
    series = Series.create!(name: "Test Series", created_by: @user)
    get series_path(series)
    assert_response :success
  end

  test "get edit when user is producer" do
    series = Series.create!(name: "Test Series", created_by: @user)
    get edit_series_path(series)
    assert_response :success
  end

  test "get edit redirects when user is not producer" do
    series = Series.create!(name: "Test Series", created_by: User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12"))
    get edit_series_path(series)
    assert_redirected_to series_path(series)
    assert_match /producer/, flash[:alert]
  end

  test "update series when user is producer" do
    series = Series.create!(name: "Old Name", created_by: @user)
    patch series_path(series), params: { series: { name: "New Name", description: "Updated." } }
    assert_redirected_to series
    series.reload
    assert_equal "New Name", series.name
  end

  test "update series redirects when user is not producer" do
    series = Series.create!(name: "Old Name", created_by: User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12"))
    patch series_path(series), params: { series: { name: "New Name" } }
    assert_redirected_to series_path(series)
    series.reload
    assert_equal "Old Name", series.name
  end

  test "destroy series when user is producer" do
    series = Series.create!(name: "To Delete", created_by: @user)
    assert_difference "Series.count", -1 do
      delete series_path(series)
    end
    assert_redirected_to series_index_path
  end

  test "destroy series redirects when user is not producer" do
    series = Series.create!(name: "To Delete", created_by: User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12"))
    assert_no_difference "Series.count" do
      delete series_path(series)
    end
    assert_redirected_to series_path(series)
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
