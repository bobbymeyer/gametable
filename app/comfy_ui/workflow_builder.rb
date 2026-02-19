# frozen_string_literal: true

module ComfyUI
  class WorkflowBuilder
    TEMPLATES_DIR = Rails.root.join("config/comfy_ui/workflows")

    def self.build(workflow_name, inputs = {})
      new(workflow_name, inputs).build
    end

    def initialize(workflow_name, inputs = {})
      @workflow_name = workflow_name
      @inputs = inputs.transform_keys(&:to_s)
    end

    def build
      template = load_template
      inject_inputs(template, @inputs)
    end

    private

    def load_template
      path = TEMPLATES_DIR.join("#{@workflow_name}.json")
      raise ArgumentError, "Workflow not found: #{@workflow_name}" unless path.exist?

      JSON.parse(File.read(path))
    end

    def inject_inputs(obj, inputs)
      return obj if inputs.empty?

      case obj
      when Hash
        obj.transform_values { |v| inject_inputs(v, inputs) }
      when Array
        obj.map { |v| inject_inputs(v, inputs) }
      when String
        inputs.reduce(obj) { |str, (key, value)| str.gsub("{{#{key}}}", value.to_s) }
      else
        obj
      end
    end
  end
end
