require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "get new" do
    get new_user_path
    assert_response :success
  end

  test "create first user as admin" do
    assert_equal 0, User.count
    post users_path, params: {
      user: { email: "first@example.com", password: "secret12", password_confirmation: "secret12" }
    }
    assert_redirected_to root_path
    user = User.find_by!(email: "first@example.com")
    assert user.admin?
  end

  test "create second user as non-admin" do
    User.create!(email: "first@example.com", password: "secret12", password_confirmation: "secret12")
    post users_path, params: {
      user: { email: "second@example.com", password: "secret12", password_confirmation: "secret12" }
    }
    assert_redirected_to root_path
    user = User.find_by!(email: "second@example.com")
    assert_not user.admin?
  end

  test "unauthenticated cannot set admin via params" do
    User.create!(email: "first@example.com", password: "secret12", password_confirmation: "secret12")
    post users_path, params: {
      user: { email: "hacker@example.com", password: "secret12", password_confirmation: "secret12", admin: true }
    }
    user = User.find_by!(email: "hacker@example.com")
    assert_not user.admin?
  end

  test "authenticated admin can create user with admin" do
    admin = User.create!(email: "admin@example.com", password: "secret12", password_confirmation: "secret12")
    admin.update_column(:admin, true)

    post login_path, params: { session: { email: "admin@example.com", password: "secret12" } }
    post users_path, params: {
      user: { email: "newadmin@example.com", password: "secret12", password_confirmation: "secret12", admin: true }
    }
    user = User.find_by!(email: "newadmin@example.com")
    assert user.admin?
  end

  test "authenticated non-admin cannot create admin user" do
    User.create!(email: "first@example.com", password: "secret12", password_confirmation: "secret12")
    regular = User.create!(email: "regular@example.com", password: "secret12", password_confirmation: "secret12")
    regular.update_column(:admin, false)

    post login_path, params: { session: { email: "regular@example.com", password: "secret12" } }
    post users_path, params: {
      user: { email: "wouldbeadmin@example.com", password: "secret12", password_confirmation: "secret12", admin: true }
    }
    user = User.find_by!(email: "wouldbeadmin@example.com")
    assert user.present?
    assert_not user.admin?
  end

  test "create with invalid params re-renders new" do
    post users_path, params: {
      user: { email: "invalid", password: "short", password_confirmation: "short" }
    }
    assert_response :unprocessable_entity
  end
end
