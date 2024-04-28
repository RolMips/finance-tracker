# frozen_string_literal: true

class Stock < ApplicationRecord
  def self.get_price(ticker_symbol)
    stock_timeseries = Alphavantage::TimeSeries.new(symbol: ticker_symbol)
    stock_timeseries.quote.price
  end
end
