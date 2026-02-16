require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
  end

  test "get login" do
    get login_path
    assert_response :success
  end

  test "create with valid credentials sets session and redirects" do
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
    assert_redirected_to root_path
    assert_equal @user.id, session[:user_id]
  end

  test "create with invalid credentials does not set session" do
    post login_path, params: { session: { email: "user@example.com", password: "wrong" } }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "destroy clears session" do
    post login_path, params: { session: { email: "user@example.com", password: "secret12" } }
    assert session[:user_id].present?

    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:user_id]
  end
end
