require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "get index without authentication" do
    get root_path
    assert_response :success
  end

  test "index shows app branding" do
    get root_path
    assert_select "h1", text: /Gametable/
    assert_match /AI Gametable/, response.body
  end
end
