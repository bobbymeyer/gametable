# frozen_string_literal: true

# Load ComfyUI namespace after app load (app/comfy_ui is an autoload root so its files are not autoloaded as ComfyUI::*).
# RunWorkflowJob subclasses ApplicationJob, so we must load after the application is initialized.
Rails.application.config.after_initialize do
  %w[client workflow_builder run_workflow_job].each do |basename|
    require Rails.root.join("app/comfy_ui/#{basename}.rb")
  end
end

# For local ComfyUI: set COMFYUI_PATH to your ComfyUI clone; the comfy process in Procfile.dev
# (started by bin/dev) will then run ComfyUI on port 8188. Leave unset to skip.
Rails.application.config.comfyui = ActiveSupport::OrderedOptions.new
Rails.application.config.comfyui.url = ENV.fetch("COMFYUI_URL", "http://localhost:8188")
Rails.application.config.comfyui.api_key = ENV["COMFYUI_API_KEY"]
Rails.application.config.comfyui.poll_interval_seconds = (ENV["COMFYUI_POLL_INTERVAL"] || 2).to_i
Rails.application.config.comfyui.poll_timeout_seconds = (ENV["COMFYUI_POLL_TIMEOUT"] || 300).to_i
