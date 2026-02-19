# frozen_string_literal: true

module ComfyUI
  class Client
    class Error < StandardError; end
    class TimeoutError < Error; end
    class SubmissionError < Error; end

    def initialize(base_url: nil, api_key: nil, poll_interval: nil, poll_timeout: nil)
      config = Rails.application.config.comfyui
      @base_url = (base_url || config.url).to_s.chomp("/")
      @api_key = api_key || config.api_key
      @poll_interval = (poll_interval || config.poll_interval_seconds).to_i
      @poll_timeout = (poll_timeout || config.poll_timeout_seconds).to_i
    end

    def run(workflow_json)
      prompt_id = submit(workflow_json)
      wait_until_complete(prompt_id)
      fetch_outputs(prompt_id)
    end

    def submit(workflow_json)
      body = { prompt: workflow_json }.to_json
      response = post("/prompt", body, "Content-Type" => "application/json")
      data = parse_json(response.body)

      raise SubmissionError, data["error"] if data["error"]
      raise SubmissionError, "No prompt_id in response" unless data["prompt_id"]

      data["prompt_id"]
    end

    def wait_until_complete(prompt_id)
      deadline = Time.now + @poll_timeout
      loop do
        raise TimeoutError, "Workflow did not complete within #{@poll_timeout}s" if Time.now >= deadline

        history = get("/history/#{prompt_id}")
        data = parse_json(history.body)
        entry = data[prompt_id]
        break if entry && entry["outputs"].present?

        sleep @poll_interval
      end
    end

    def fetch_outputs(prompt_id)
      history = get("/history/#{prompt_id}")
      data = parse_json(history.body)
      node_outputs = data[prompt_id]&.dig("outputs") || {}
      images = collect_output_images(node_outputs)
      images.map { |img| fetch_image(img) }
    end

    private

    def collect_output_images(node_outputs)
      node_outputs.flat_map do |_node_id, out|
        next [] unless out.is_a?(Hash)

        list = out["images"] || out["gifs"] || []
        list.map do |entry|
          {
            "filename" => entry["filename"],
            "subfolder" => entry["subfolder"],
            "type" => entry["type"] || "output"
          }
        end
      end
    end

    def fetch_image(entry)
      params = URI.encode_www_form(
        "filename" => entry["filename"],
        "subfolder" => entry["subfolder"].to_s,
        "type" => entry["type"].to_s
      )
      path = "/view?#{params}"
      response = get(path)
      raise Error, "Failed to fetch image: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      {
        filename: entry["filename"],
        data: response.body
      }
    end

    def post(path, body, headers = {})
      request = Net::HTTP::Post.new(uri(path))
      default_headers.merge(headers).each { |k, v| request[k] = v }
      request.body = body
      http.request(request)
    end

    def get(path)
      request = Net::HTTP::Get.new(uri(path))
      default_headers.each { |k, v| request[k] = v }
      http.request(request)
    end

    def uri(path)
      path = "/#{path}" unless path.start_with?("/")
      URI("#{@base_url}#{path}")
    end

    def http
      u = URI(@base_url)
      Net::HTTP.new(u.hostname, u.port).tap do |h|
        h.use_ssl = (u.scheme == "https")
        h.open_timeout = 10
        h.read_timeout = 60
      end
    end

    def default_headers
      h = {}
      h["X-API-Key"] = @api_key if @api_key.present?
      h
    end

    def parse_json(str)
      JSON.parse(str)
    rescue JSON::ParserError => e
      raise Error, "Invalid JSON: #{e.message}"
    end
  end
end
