require 'alphavantage'

Alphavantage.configure do |config|
  config.api_key = Rails.application.credentials.alphavantage[:api_key]
end
