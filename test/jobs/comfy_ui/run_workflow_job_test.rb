# frozen_string_literal: true

require "minitest/mock"
require "test_helper"

class ComfyUIRunWorkflowJobTest < ActiveJob::TestCase
  setup do
    @series = Series.create!(name: "Test Series")
    @location = @series.locations.create!(name: "The Tavern")
  end

  test "perform builds workflow runs client and attaches first image to record" do
    workflow = { "1" => { "class_type" => "CLIPTextEncode", "inputs" => { "text" => "test" } } }
    results = [ { filename: "gen.png", data: "fake-png-bytes" } ]
    mock_client = Minitest::Mock.new
    mock_client.expect :run, results, [ workflow ]
    ::ComfyUI::Client.stub :new, mock_client do
      ::ComfyUI::WorkflowBuilder.stub :build, workflow do
        ::ComfyUI::RunWorkflowJob.perform_now(
          "placeholder",
          { "prompt" => "test" },
          "attach" => { "record" => "Location", "id" => @location.id, "name" => "backdrop" }
        )
      end
    end
    mock_client.verify
    @location.reload
    assert @location.backdrop.attached?
    assert_equal "gen.png", @location.backdrop.filename.to_s
  end

  test "perform with symbol keys in result_target" do
    workflow = { "1" => {} }
    results = [ { filename: "out.png", data: "image-data" } ]
    mock_client = Minitest::Mock.new
    mock_client.expect :run, results, [ Hash ]
    ::ComfyUI::Client.stub :new, mock_client do
      ::ComfyUI::WorkflowBuilder.stub :build, workflow do
        ::ComfyUI::RunWorkflowJob.perform_now(
          "placeholder",
          {},
          "attach" => { "record" => "Location", "id" => @location.id, "name" => "backdrop" }
        )
      end
    end
    @location.reload
    assert @location.backdrop.attached?
  end

  test "perform no-ops when results empty" do
    workflow = { "1" => {} }
    mock_client = Minitest::Mock.new
    mock_client.expect :run, [], [ workflow ]
    ::ComfyUI::Client.stub :new, mock_client do
      ::ComfyUI::WorkflowBuilder.stub :build, workflow do
        ::ComfyUI::RunWorkflowJob.perform_now(
          "placeholder",
          {},
          "attach" => { "record" => "Location", "id" => @location.id, "name" => "backdrop" }
        )
      end
    end
    @location.reload
    assert_not @location.backdrop.attached?
  end
end
