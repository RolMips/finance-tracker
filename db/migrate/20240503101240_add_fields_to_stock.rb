class AddFieldsToStock < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :company_country, :string
    add_column :stocks, :last_price_currency, :string
    add_column :stocks, :exchange_place, :string
  end
end
