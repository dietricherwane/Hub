class EcommerceProfile < ActiveRecord::Base
  # Accessible fields
  attr_accessible :description, :published

  # Relationships
  has_many :ecommerces

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    description: "Description",
    published: "Publié",
    token: "Token"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
