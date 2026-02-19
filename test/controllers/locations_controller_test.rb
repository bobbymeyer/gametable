require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
    @series = Series.create!(name: "Test Series", created_by: @user)
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
  end

  test "get new as producer" do
    get new_series_location_path(@series)
    assert_response :success
  end

  test "create location as producer" do
    assert_difference "Location.count", 1 do
      post series_locations_path(@series), params: { location: { name: "The Tavern" } }
    end
    location = Location.last
    assert_redirected_to series_path(@series, anchor: "locations")
    assert_equal "The Tavern", location.name
    assert_equal @series, location.series
  end

  test "create with invalid params re-renders new" do
    post series_locations_path(@series), params: { location: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "get edit as producer" do
    location = @series.locations.create!(name: "The Tavern")
    get edit_location_path(location)
    assert_response :success
  end

  test "update location as producer" do
    location = @series.locations.create!(name: "The Tavern")
    patch location_path(location), params: { location: { name: "The Inn" } }
    assert_redirected_to series_path(@series, anchor: "locations")
    location.reload
    assert_equal "The Inn", location.name
  end

  test "destroy location as producer" do
    location = @series.locations.create!(name: "To Delete")
    assert_difference "Location.count", -1 do
      delete location_path(location)
    end
    assert_redirected_to series_path(@series, anchor: "locations")
  end

  test "non-producer cannot get new" do
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    get new_series_location_path(@series)
    assert_redirected_to @series
    assert_match /producer/, flash[:alert]
  end

  test "non-producer cannot create location" do
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    assert_no_difference "Location.count" do
      post series_locations_path(@series), params: { location: { name: "The Tavern" } }
    end
    assert_redirected_to @series
    assert_match /producer/, flash[:alert]
  end

  test "non-producer cannot update location" do
    location = @series.locations.create!(name: "The Tavern")
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    patch location_path(location), params: { location: { name: "Hacked" } }
    assert_redirected_to @series
    location.reload
    assert_equal "The Tavern", location.name
  end

  test "non-producer cannot destroy location" do
    location = @series.locations.create!(name: "To Delete")
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    assert_no_difference "Location.count" do
      delete location_path(location)
    end
    assert_redirected_to @series
  end
end
