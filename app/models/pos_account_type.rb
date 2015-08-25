class PosAccountType < ActiveRecord::Base
  # accessible fields
  attr_accessible :name, :token

  # Relationships
  has_many :users

  # Make attributes names more friendly
  HUMANIZED_ATTRIBUTES = {
    name: "Nom",
    token: "Token"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
