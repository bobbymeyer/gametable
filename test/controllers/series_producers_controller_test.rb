require "test_helper"

class SeriesProducersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ep = User.create!(email: "ep@example.com", password: "secret12", password_confirmation: "secret12")
    @series = Series.create!(name: "Test Series", created_by: @ep)
    post login_path, params: { session: { email: "ep@example.com", password: "secret12" } }
  end

  test "executive producer can get producers index" do
    get series_series_producers_path(@series)
    assert_response :success
  end

  test "executive producer can add producer by email" do
    producer = User.create!(email: "producer@example.com", password: "secret12", password_confirmation: "secret12")
    assert_difference "@series.series_producers.count", 1 do
      post series_series_producers_path(@series), params: { email: "producer@example.com" }
    end
    assert_redirected_to series_series_producers_path(@series)
    assert @series.reload.producer?(producer)
  end

  test "executive producer can remove producer" do
    producer = User.create!(email: "producer@example.com", password: "secret12", password_confirmation: "secret12")
    sp = @series.series_producers.create!(user: producer)
    assert_difference "@series.series_producers.count", -1 do
      delete series_series_producer_path(@series, sp)
    end
    assert_redirected_to series_series_producers_path(@series)
    assert_not @series.reload.producer?(producer)
  end

  test "non-executive producer cannot manage producers" do
    producer = User.create!(email: "producer@example.com", password: "secret12", password_confirmation: "secret12")
    @series.series_producers.create!(user: producer)
    post logout_path
    post login_path, params: { session: { email: "producer@example.com", password: "secret12" } }
    get series_series_producers_path(@series)
    assert_redirected_to series_path(@series)
    assert_match /Executive Producer/, flash[:alert]
  end

  test "add producer with unknown email redirects with alert" do
    assert_no_difference "@series.series_producers.count" do
      post series_series_producers_path(@series), params: { email: "nobody@example.com" }
    end
    assert_redirected_to series_series_producers_path(@series)
    assert_match /No user found/, flash[:alert]
  end
end
