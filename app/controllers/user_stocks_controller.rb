# frozen_string_literal: true

class UserStocksController < ApplicationController
  def create
    stock = Stock.stock_find(params[:ticker])

    unless stock
      flash.now[:error] = 'Stock not found.'
      refresh_turbo_flash_messages(request.referer)
      return
    end

    user_stock = UserStock.create(user: current_user, stock:)

    if user_stock.persisted?
      @tracked_stocks = current_user.stocks.order(:ticker)
      flash.now[:success] = "#{stock.ticker} was successfully added to your portfolio."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('flash_messages', partial: 'layouts/messages'),
            turbo_stream.update('ticker_input_form', partial: 'users/ticker_input_form'),
            turbo_stream.update('api_result'),
            turbo_stream.update('portfolio', partial: 'user_stocks/list', locals: { stocks: @tracked_stocks })
          ]
        end
        format.html { redirect_to my_portfolio_path }
      end
    else
      flash.now[:error] = "Failed to add #{stock.ticker} to portfolio."
      refresh_turbo_flash_messages(my_portfolio_path)
    end
  end

  def update
    stock = Stock.find(params[:id])
    new_price = Stock.price_search(stock.ticker)
    if new_price&.to_s&.exclude?('Error:') && stock.update(last_price: new_price)
      @tracked_stocks = current_user.stocks.order(:ticker)
      flash.now[:success] = "#{stock.ticker} price was successfully updated."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('flash_messages', partial: 'layouts/messages'),
            turbo_stream.update('ticker_input_form', partial: 'users/ticker_input_form'),
            turbo_stream.update('api_result'),
            turbo_stream.update('portfolio', partial: 'user_stocks/list', locals: { stocks: @tracked_stocks })
          ]
        end
        format.html { redirect_to my_portfolio_path }
      end
    else
      flash.now[:error] = "Failed to update #{stock.ticker} price."
      refresh_turbo_flash_messages(my_portfolio_path)
    end
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.find_by(user_id: current_user.id, stock_id: stock.id)
    if user_stock.present? && user_stock.destroy
      flash.now[:success] = "#{stock.ticker} was successfully removed from portfolio."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('flash_messages', partial: 'layouts/messages'),
            turbo_stream.update('ticker_input_form', partial: 'users/ticker_input_form'),
            turbo_stream.update('api_result'),
            turbo_stream.remove("user_stock_#{stock.id}")
          ]
        end
        format.html { redirect_to my_portfolio_path }
      end
    else
      flash.now[:error] = "Failed to remove #{stock.ticker} from portfolio."
      refresh_turbo_flash_messages(my_portfolio_path)
    end
  end
end
