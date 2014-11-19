class Profile < ActiveRecord::Base

  # Relationships
  has_many :users

  # Accessible fields
  attr_accessible :name, :shortcut, :published

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    name: "Nom",
    shortcut: "Abbréviation"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, :shortcut, presence: true
  validates :name, :shortcut, uniqueness: true
  validates :name, length: {maximum: 100}
  validates :shortcut, length: {maximum: 5}

  # Custom functions
end
