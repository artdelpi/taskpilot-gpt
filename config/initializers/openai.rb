ENV["OPENAI_API_KEY"] ||= Rails.application.credentials.dig(:openai, :api_key)
