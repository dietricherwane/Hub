class Bank < ActiveRecord::Base
  # accessible fields
  attr_accessible :name, :published

  # Relationships
  has_many :ecommerces

  # Make attributes names more friendly
  HUMANIZED_ATTRIBUTES = {
    name: "Nom"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, presence: true
  validates :name, length: {maximum: 100}
end
