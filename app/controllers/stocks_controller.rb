# frozen_string_literal: true

class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.full_search(params[:stock])
      @error_message = @stock if @stock.to_s.include?('Error:')
    else
      @error_message = 'Error: Please enter a stock ticker symbol !'
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('api_result', partial: 'users/api_result'),
          turbo_stream.update('flash_messages', partial: 'layouts/messages')
        ]
      end
      format.html { redirect_to my_portfolio_path }
    end
  end
end
