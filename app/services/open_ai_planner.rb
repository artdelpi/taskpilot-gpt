class OpenAIPlanner
  def initialize
    @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  end

  def suggest_tasks(project_name, context = "")
    system_msg = "You are a project planner. Return STRICT JSON only."
    user_msg = <<~MSG
      Generate 5 initial tasks for the project "#{project_name}".
      Include: title, description, due_date (YYYY-MM-DD), priority (low|normal|high).
      Project context: #{context}
      Respond ONLY with a JSON array.
    MSG

    resp = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        temperature: 0.7,
        messages: [
          { role: "system", content: system_msg },
          { role: "user",   content: user_msg }
        ]
      }
    )

    text = resp.dig("choices", 0, "message", "content").to_s
    JSON.parse(text)
  end
end
