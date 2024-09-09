# frozen_string_literal: true

require 'httparty'
class AlphaVantageService
  include HTTParty
  base_uri 'https://www.alphavantage.co'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_company_data(symbol)
    response = self.class.get('/query', query: { function: 'OVERVIEW', symbol:, apikey: @api_key })
    handle_response(response)

    company_data = response.parsed_response
    {
      name: company_data['Name'],
      currency: company_data['Currency'],
      country: company_data['Country'],
      exchange: company_data['Exchange']
    }
  end

  def get_quote_data(symbol)
    response = self.class.get('/query', query: { function: 'GLOBAL_QUOTE', symbol:, apikey: @api_key })
    handle_response(response)

    quote_data = response.parsed_response['Global Quote']
    {
      price: quote_data['05. price']
    }
  end

  private

  def handle_response(response)
    raise AlphaVantageError, "#{response.code} - #{response.message}" unless response.success?
    raise AlphaVantageError, 'Stock ticker symbol not found !' if response.blank?

    data = response.parsed_response
    raise AlphaVantageError, data['Information'] if data['Information']
  end

  class AlphaVantageError < StandardError; end
end
