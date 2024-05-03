# frozen_string_literal: true

class StocksController < ApplicationController
  def search
    if stock_symbol.present?
      alpha_vantage = AlphaVantageService.new(api_key)
      begin
        @company_data = alpha_vantage.get_company_data(stock_symbol)
        @quote_data = alpha_vantage.get_quote_data(stock_symbol)
      rescue AlphaVantageService::AlphaVantageError || AlphaVantageService::StandardError => e
        @error_message = "Error: #{e.message}"
      end
    else
      @error_message = 'Error: Please enter a stock ticker symbol !'
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          'api_result',
          partial: 'users/api_result'
        )
      end
    end
  end

  private

  def api_key
    Rails.application.credentials.alphavantage[:api_key]
  end

  def stock_symbol
    params[:stock]
  end
end
