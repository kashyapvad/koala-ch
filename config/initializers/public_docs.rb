require 'httparty'

begin
  response = HTTParty.get(ENV['PUBLIC_DOCS_MARK_DOWN_URL'])

  if response.success?
    PUBLIC_DOCS_MARK_DOWN = response.parsed_response
  else
    Rails.logger.error("Failed to fetch public docs data: #{response.code} #{response.message}")
  end
rescue SocketError => e
  Rails.logger.error("Socket error occurred: #{e.message}")
rescue StandardError => e
  Rails.logger.error("An error occurred while fetching public docs data: #{e.message}")
end