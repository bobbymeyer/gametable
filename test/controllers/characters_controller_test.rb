require "test_helper"

class CharactersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
    @series = Series.create!(name: "Test Series", created_by: @user)
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
  end

  test "get new as producer" do
    get new_series_character_path(@series)
    assert_response :success
  end

  test "get show" do
    character = @series.cast.create!(name: "Hero")
    get character_path(character)
    assert_response :success
  end

  test "create character as producer" do
    assert_difference "Character.count", 1 do
      post series_characters_path(@series), params: {
        character: { name: "Hero" }
      }
    end
    character = Character.last
    assert_redirected_to @series
    assert_equal "Hero", character.name
    assert_equal 0, character.xp
    assert_equal @series, character.series
  end

  test "create with invalid params re-renders new" do
    post series_characters_path(@series), params: { character: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "non-producer cannot get new" do
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    get new_series_character_path(@series)
    assert_redirected_to @series
    assert_match /producer/, flash[:alert]
  end

  test "non-producer cannot create character" do
    other = User.create!(email: "other@example.com", password: "secret12", password_confirmation: "secret12")
    post logout_path
    post login_path, params: { session: { email: "other@example.com", password: "secret12" } }
    assert_no_difference "Character.count" do
      post series_characters_path(@series), params: { character: { name: "Hero" } }
    end
    assert_redirected_to @series
    assert_match /producer/, flash[:alert]
  end
end
