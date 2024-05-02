# frozen_string_literal: true

class StocksController < ApplicationController
  def search
    alpha_vantage = AlphaVantageService.new(api_key)
    begin
      @company_data = alpha_vantage.get_company_data(stock_symbol)
      @quote_data = alpha_vantage.get_quote_data(stock_symbol)
    rescue AlphaVantageError => e
      @error_message = "Error retrieving stock data: #{e.message}"
    rescue StandardError => e
      @error_message = "An unexpected error occurred: #{e.message}"
    end
    render 'users/my_portfolio'
  end

  private

  def api_key
    Rails.application.credentials.alphavantage[:api_key]
  end

  def stock_symbol
    params[:stock]
  end
end
