# frozen_string_literal: true

class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks.order(:ticker)
  end
end
