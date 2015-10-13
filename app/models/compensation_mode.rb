class CompensationMode < ActiveRecord::Base

  # Accessible fields
  attr_accessible :description, :shortcut, :published

  # Relationships
  has_many :users

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    description: "Mode",
    shortcut: "Abbréviation",
  }

  def self.human_attribute_name
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
