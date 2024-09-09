# frozen_string_literal: true

module UserStocksHelper
  def stock_already_tracked?(ticker_symbol)
    false unless Stock.stock_find(ticker_symbol)

    current_user.stocks.exists?(ticker: ticker_symbol)
  end

  def portfolio_count?
    current_user.stocks.count
  end
end
