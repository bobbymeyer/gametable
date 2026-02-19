# frozen_string_literal: true

require "test_helper"

class ComfyUIWorkflowBuilderTest < ActiveSupport::TestCase
  test "build loads template and injects inputs" do
    result = ::ComfyUI::WorkflowBuilder.build("placeholder", "prompt" => "a dark forest")
    assert result.is_a?(Hash)
    assert_equal "a dark forest", result["1"]["inputs"]["text"]
  end

  test "build with symbol keys" do
    result = ::ComfyUI::WorkflowBuilder.build("placeholder", prompt: "symbol prompt")
    assert_equal "symbol prompt", result["1"]["inputs"]["text"]
  end

  test "build raises for unknown workflow" do
    assert_raises(ArgumentError) { ::ComfyUI::WorkflowBuilder.build("nonexistent", {}) }
  end

  test "build with empty inputs leaves placeholders" do
    result = ::ComfyUI::WorkflowBuilder.build("placeholder", {})
    assert_equal "{{prompt}}", result["1"]["inputs"]["text"]
  end
end
