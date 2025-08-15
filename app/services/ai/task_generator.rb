module Ai
  class TaskGenerator
    MAX_RETRIES  = 2
    BASE_BACKOFF = 1.0

    def initialize(project)
      @project = project
    end

    def call(count: 5)
      retries = 0
      begin
        suggestions = remote_suggestions(count: count)
        return normalize(suggestions, count: count)
      rescue Faraday::TooManyRequestsError => e
        if retries < MAX_RETRIES
          sleep backoff_for(retries)
          retries += 1
          retry
        end
        Rails.logger.warn("[AI] 429 depois de retries; usando fallback: #{e.message}")
        return self.class.local_suggestions(@project, count: count)
      rescue JSON::ParserError => e
        Rails.logger.warn("[AI] resposta não-JSON; usando fallback: #{e.message}")
        return self.class.local_suggestions(@project, count: count)
      rescue => e
        Rails.logger.warn("[AI] erro no gerador; usando fallback: #{e.class} #{e.message}")
        return self.class.local_suggestions(@project, count: count)
      end
    end

    def self.local_suggestions(project, count: 5)
      base = project&.name.presence || "New Project"
      desc = project&.description.to_s

      (1..count.to_i).map do |i|
        {
          title: "#{base}: Task #{i}",
          description: desc.present? ? "Subtask #{i} — #{desc}" : "Auto-suggested task #{i}.",
          due_date: (Date.today + i.days).to_s
        }
      end
    end

    private

    def remote_suggestions(count:)
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

      prompt = <<~TXT
        Gere #{count} tarefas iniciais em JSON puro (array), cada item com:
        "title", "description", "due_date" (YYYY-MM-DD).
        Projeto: #{@project&.name}
        Contexto: #{@project&.description}
        Responda apenas com JSON.
      TXT

      resp = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "Você é um planejador de projetos." },
            { role: "user",   content: prompt }
          ],
          temperature: 0.7,
          max_tokens: 400
        }
      )

      content = resp.dig("choices", 0, "message", "content").to_s
      parse_json(content)
    end

    def parse_json(content)
      json = content
               .sub(/\A```json\s*/m, "")
               .sub(/\A```\s*/m, "")
               .sub(/```\s*\z/m, "")
      JSON.parse(json)
    end

    def normalize(arr, count:)
      Array(arr).first(count.to_i).map do |h|
        {
          title:       h["title"] || h[:title],
          description: h["description"] || h[:description],
          due_date:    h["due_date"] || h[:due_date]
        }
      end
    end

    def backoff_for(i)
      jitter = rand * 0.5
      (BASE_BACKOFF * (2 ** i)) + jitter
    end
  end
end
