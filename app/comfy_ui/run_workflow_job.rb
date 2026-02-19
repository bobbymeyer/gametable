# frozen_string_literal: true

module ComfyUI
  class RunWorkflowJob < ::ApplicationJob
    queue_as :default

    retry_on ComfyUI::Client::TimeoutError, wait: :polynomially_longer, attempts: 2
    retry_on StandardError, wait: :polynomially_longer, attempts: 3

    def perform(workflow_name, inputs, result_target)
      workflow_json = WorkflowBuilder.build(workflow_name, inputs)
      results = client.run(workflow_json)
      apply_result_target(result_target, results)
    end

    private

    def client
      @client ||= ComfyUI::Client.new
    end

    def apply_result_target(target, results)
      attach = target["attach"] || target[:attach]
      return unless attach

      record_class = (attach["record"] || attach[:record]).to_s.constantize
      record_id = attach["id"] || attach[:id]
      attachment_name = (attach["name"] || attach[:attachment_name]).to_sym
      record = record_class.find(record_id)
      first_image = results.find { |r| r[:data].present? }
      return if first_image.blank?

      record.public_send(attachment_name).attach(
        io: StringIO.new(first_image[:data]),
        filename: first_image[:filename].presence || "output.png",
        content_type: "image/png"
      )
    end
  end
end
