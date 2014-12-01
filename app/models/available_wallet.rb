class AvailableWallet < ActiveRecord::Base
  # Accessible fields
  attr_accessible :ecommerce_id, :wallet_id, :published, :unpublished_by, :unpublished_at, :published_by, :published_at

  # Relationships
  belongs_to :ecommerce
  belongs_to :wallet

  # Validations
  validates :ecommerce_id, :wallet_id, presence: true
end
