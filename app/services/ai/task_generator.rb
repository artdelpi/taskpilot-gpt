require "json"

module Ai
  class TaskGenerator
    def initialize(project)
      @project = project
      @client  = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    end

    def call(count: 5)
      prompt = <<~PROMPT
        You are an assistant that breaks a project into clear, realistic, actionable tasks.
        Return ONLY a valid JSON array. Each item must be:
        { "title": "...", "description": "...", "due_date": "YYYY-MM-DD" }

        Project: "#{@project.name}"
        Description: "#{@project.description}"
        Number of tasks: #{count}
      PROMPT

      resp = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          temperature: 0.5,
          messages: [
            { role: "system", content: "Return only JSON. No prose." },
            { role: "user",   content: prompt }
          ]
        }
      )

      raw = resp.dig("choices", 0, "message", "content").to_s
      parse_json_array(raw)
    end

    private

    def parse_json_array(text)
      json = text[/\[[\s\S]*\]\s*\z/] || text
      JSON.parse(json)
          .select { |i| i.is_a?(Hash) && i["title"].present? }
          .map do |h|
            {
              title:       h["title"].to_s.first(255),
              description: h["description"].to_s,
              due_date:    safe_date(h["due_date"])
            }
          end
    rescue JSON::ParserError
      []
    end

    def safe_date(val)
      Date.parse(val.to_s) rescue nil
    end
  end
end
