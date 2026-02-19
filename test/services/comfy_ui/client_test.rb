# frozen_string_literal: true

require "minitest/mock"
require "net/http"
require "ostruct"
require "test_helper"

class ComfyUIClientTest < ActiveSupport::TestCase
  setup do
    @client = ::ComfyUI::Client.new(base_url: "http://localhost:8188", poll_interval: 0, poll_timeout: 2)
  end

  test "submit posts workflow and returns prompt_id" do
    stub_http([ post_response('{"prompt_id":"pid-123"}') ]) do
      id = @client.submit({ "1" => { "class_type" => "Test", "inputs" => {} } })
      assert_equal "pid-123", id
    end
  end

  test "submit raises SubmissionError on API error" do
    stub_http([ post_response('{"error":"Invalid node"}') ]) do
      assert_raises(::ComfyUI::Client::SubmissionError) { @client.submit({}) }
    end
  end

  test "submit raises SubmissionError when prompt_id missing" do
    stub_http([ post_response("{}") ]) do
      assert_raises(::ComfyUI::Client::SubmissionError) { @client.submit({}) }
    end
  end

  test "fetch_outputs parses history and fetches image" do
    history_body = {
      "pid-1" => {
        "outputs" => {
          "7" => {
            "images" => [ { "filename" => "out.png", "subfolder" => "", "type" => "output" } ]
          }
        }
      }
    }.to_json
    view_response = image_response
    stub_http([ get_response(history_body), view_response ]) do
      results = @client.fetch_outputs("pid-1")
      assert_equal 1, results.size
      assert_equal "out.png", results[0][:filename]
      assert_equal "\x89PNG", results[0][:data]
    end
  end

  test "run submits then waits then fetches and returns outputs" do
    workflow = { "1" => {} }
    history_with_outputs = {
      "pid-1" => {
        "outputs" => {
          "7" => { "images" => [ { "filename" => "x.png", "subfolder" => "", "type" => "output" } ] }
        }
      }
    }.to_json
    responses = [
      post_response('{"prompt_id":"pid-1"}'),
      get_response("{}"),
      get_response(history_with_outputs),
      get_response(history_with_outputs),
      image_response
    ]
    stub_http(responses) do
      results = @client.run(workflow)
      assert_equal 1, results.size
      assert_equal "x.png", results[0][:filename]
      assert_equal "\x89PNG", results[0][:data]
    end
  end

  private

  def stub_http(responses)
    mock = Minitest::Mock.new
    responses.each { |r| mock.expect :request, r, [ Object ] }
    @client.stub :http, mock do
      yield
    end
    mock.verify
  end

  def post_response(body)
    OpenStruct.new(body: body, code: "200").tap do |r|
      r.define_singleton_method(:is_a?) { |k| k == Net::HTTPSuccess }
    end
  end

  def get_response(body)
    post_response(body)
  end

  def image_response
    OpenStruct.new(body: "\x89PNG", code: "200").tap do |r|
      r.define_singleton_method(:is_a?) { |k| k == Net::HTTPSuccess }
    end
  end
end
