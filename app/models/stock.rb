# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks

  validates :ticker, :name, :company_country, :last_price_currency, :exchange_place, presence: true
end
