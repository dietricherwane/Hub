class PosCashout < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Accessible fields
  attr_accessible :amount, :transaction_id, :user_id, :request_body, :request_response

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    amount: "Montant",
    id: ""
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates :user_id, :amount, :transaction_id, presence: true
  validates :amount, numericality: true
end
