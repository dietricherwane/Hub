class Country < ActiveRecord::Base
  # Accessible fields
  attr_accessible :name, :published

  # Relationships
  has_many :users

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    name: "Nom"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, presence: true
end
