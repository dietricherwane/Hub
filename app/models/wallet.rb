class Wallet < ActiveRecord::Base
  # Accessible fields
  attr_accessible :name, :country_id, :authentication_token, :fee, :published

  # Relationships
  has_many :available_wallets
  has_many :ecommerces, through: :available_wallets
end
