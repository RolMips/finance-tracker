# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks

  validates :ticker, :name, :company_country, :last_price_currency, :exchange_place, presence: true
  validates :ticker, uniqueness: true

  def self.full_search(ticker_symbol)
    alpha_vantage = AlphaVantageService.new(Rails.application.credentials.alphavantage[:api_key])
    begin
      stock = stock_find(ticker_symbol)
      unless stock
        company_data = alpha_vantage.get_company_data(ticker_symbol)
        quote_data = alpha_vantage.get_quote_data(ticker_symbol)
        stock = new(ticker: ticker_symbol,
                    name: company_data[:name],
                    last_price: quote_data[:price],
                    company_country: company_data[:country],
                    last_price_currency: company_data[:currency],
                    exchange_place: company_data[:exchange])
        stock.save
      end
      stock
    rescue AlphaVantageService::AlphaVantageError || AlphaVantageService::StandardError => e
      "Error: #{e.message}"
    end
  end

  def self.price_search(ticker_symbol)
    alpha_vantage = AlphaVantageService.new(Rails.application.credentials.alphavantage[:api_key])
    begin
      quote_data = alpha_vantage.get_quote_data(ticker_symbol)
      quote_data[:price]
    rescue AlphaVantageService::AlphaVantageError || AlphaVantageService::StandardError => e
      "Error: #{e.message}"
    end
  end

  def self.stock_find(ticker_symbol)
    find_by(ticker: ticker_symbol)
  end
end
