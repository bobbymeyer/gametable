require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(email: "user@example.com", password: "secret12", password_confirmation: "secret12")
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "secret12", password_confirmation: "secret12")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid with duplicate email" do
    User.create!(email: "same@example.com", password: "secret12", password_confirmation: "secret12")
    user = User.new(email: "same@example.com", password: "secret12", password_confirmation: "secret12")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "invalid with invalid email format" do
    user = User.new(email: "not-an-email", password: "secret12", password_confirmation: "secret12")
    assert_not user.valid?
    assert_includes user.errors[:email], "is invalid"
  end

  test "invalid with short password" do
    user = User.new(email: "user@example.com", password: "short", password_confirmation: "short")
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 6 characters)"
  end

  test "first user is admin" do
    assert_equal 0, User.count
    user = User.create!(email: "first@example.com", password: "secret12", password_confirmation: "secret12")
    assert user.admin?
  end

  test "second user is not admin" do
    User.create!(email: "first@example.com", password: "secret12", password_confirmation: "secret12")
    user = User.create!(email: "second@example.com", password: "secret12", password_confirmation: "secret12")
    assert_not user.admin?
  end

  test "authenticate_by returns user with valid credentials" do
    user = User.create!(email: "auth@example.com", password: "secret12", password_confirmation: "secret12")
    found = User.authenticate_by(email: "auth@example.com", password: "secret12")
    assert_equal user, found
  end

  test "authenticate_by returns nil with wrong password" do
    User.create!(email: "auth@example.com", password: "secret12", password_confirmation: "secret12")
    assert_nil User.authenticate_by(email: "auth@example.com", password: "wrong")
  end

  test "authenticate_by returns nil with unknown email" do
    assert_nil User.authenticate_by(email: "nobody@example.com", password: "secret12")
  end
end
