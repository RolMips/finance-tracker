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
      render 'users/my_portfolio'
    else
      flash[:danger] = 'Please enter a stock ticker symbol !'
      redirect_to my_portfolio_path
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
