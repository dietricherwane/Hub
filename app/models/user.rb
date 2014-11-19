class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  # Relationships
  belongs_to :profile
  has_many :ecommerces
  belongs_to :country

  # Accessible fields
  attr_accessible :firstname, :lastname, :country_id, :email, :address, :phone_number, :mobile_number, :profile_id, :published, :password

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    firstname: "Nom",
    lastname: "Prénom",
    country_id: "Pays",
    email: "Email",
    address: "Adresse",
    phone_number: "Numéro de téléphone fixe",
    mobile_number: "Numéro de téléphone mobile",
    password_confirmation: "Confirmation de mot de passe",
    created_at: "Compte créé le"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :firstname, :lastname, :country_id, :address, :mobile_number, presence: true
  validates :firstname, :lastname, length: {maximum: 100}
  validates :phone_number, :mobile_number, length: {minimum: 8, maximum: 16, allow_blank: true}
  validates :phone_number, :mobile_number, numericality: {allow_blank: true}

  # Custom functions
  def admin?
    return profile.shortcut == "ADMIN"
  end

  def merchant?
    return profile.shortcut == "MER"
  end

  def profile_shortcut
    return profile.shortcut
  end

  def full_name
    return "[ #{lastname} #{firstname} ]"
  end

  def has_ecommerce
    return !ecommerces.empty?
  end

  # Callbacks
  before_save :format_fields
  before_update :format_fields

  private
  def format_fields
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname)
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname)
  end
end
